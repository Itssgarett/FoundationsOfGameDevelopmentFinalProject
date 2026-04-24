extends Node2D

@export var tower_scene: PackedScene
@export var tower_scene2: PackedScene
@export var enemy_scene: PackedScene
@export var enemy_scene2: PackedScene


var enemies_alive = 0
var current_round = 1 
var enemies_per_round = 5 
var placing_tower = false
var money = 100
var tower1_cost = 100
var tower2_cost = 200
var preview_tower = null
var selected_tower = 1 
var player_health = 10
var game_over = false
var round_active = false

var active_tower = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_money_ui()
	update_health_ui()
	update_round_ui()
	spawn_round(enemies_per_round)

func spawn_round(amount):
	round_active = true
	
	for i in range(amount):
		if game_over:
			return
			
		spawn_enemy()
		await get_tree().create_timer(0.5).timeout
		
func spawn_enemy():
	if game_over:
		return
		
	var enemy
	if current_round >= 5:
		if randi() % 2 ==0:
			enemy = enemy_scene.instantiate()
		else:
			enemy = enemy_scene2.instantiate()
	else:
		enemy = enemy_scene.instantiate()
	$Path2D.add_child(enemy)
	enemies_alive += 1

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("CLICK DETECTED")
		
		if placing_tower:
			if event.button_index == MOUSE_BUTTON_LEFT:
				
				var mouse_pos = get_global_mouse_position()
				
				if is_on_path(mouse_pos):
					$UI/InstructionLabel.text = "Can't place here"
					$UI/InstructionLabel.visible = true
			
					await get_tree().create_timer(1.5).timeout
			
					$UI/InstructionLabel.visible = false
					return
				
				var cost = 0 
				if selected_tower == 1:
					cost = tower1_cost
				else:
					cost = tower2_cost

				if money >= cost:
					money -= cost
					update_money_ui()
	
					place_tower(mouse_pos)
	
					placing_tower = false
					$UI/InstructionLabel.visible = false
				else:
					$UI/InstructionLabel.text = "Not enough money!"
					$UI/InstructionLabel.visible = true
					await get_tree().create_timer(1.5).timeout
					$UI/InstructionLabel.visible = false
					placing_tower = false

func place_tower(pos):
	print("PLACING TOWER")
	
	var tower
	if selected_tower == 1:
		tower = tower_scene.instantiate()
	else:
		tower = tower_scene2.instantiate()
	
	tower.position = pos
	
	tower.connect("tower_selected", _on_tower_selected)
	
	add_child(tower)
	
func is_on_path(pos):
	var tilemap = $TileMap   # change name if needed
	
	var cell = tilemap.local_to_map(tilemap.to_local(pos))
	
	var source_id = tilemap.get_cell_source_id(0, cell)
	var atlas_coords = tilemap.get_cell_atlas_coords(0, cell)
	
	return source_id == 3 and atlas_coords in [
		Vector2i(17,8),

		Vector2i(17,6),
		Vector2i(11,4),
		Vector2i(13,3),
		Vector2i(14,3),
		Vector2i(13,4),
		]

func update_money_ui():
	$UI/MoneyLabel.text = "Money: " + str(money)

func update_health_ui():
	$UI/HealthLabel.text = "Health: " + str(player_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_health <= 0:
		for child in $UI.get_children():
			child.visible = false
			$UI/GameOverLabel.visible = true
			get_tree().paused = true
			return
			
	if enemies_alive == 0 and round_active and !game_over:
		round_active = false
		start_next_round()

func start_next_round():
	current_round += 1
	enemies_per_round += 5
	
	update_round_ui()
	
	print("Starting Round:", current_round)
	
	spawn_round(enemies_per_round)

func update_round_ui():
	$UI/RoundLabel.text = "Round: " + str(current_round)

func _on_tower_button_pressed() -> void:
	selected_tower = 1
	placing_tower = true
	print("Tower 1 Selected")
	
	$UI/InstructionLabel.text = "Click on the map to place the tower"
	$UI/InstructionLabel.visible = true
	


func _on_tower_button_2_pressed() -> void:
	selected_tower = 2
	placing_tower = true
	print("Tower 2 Selected")
	
	$UI/InstructionLabel.text = "Click on the map to place the tower"
	$UI/InstructionLabel.visible = true



func _on_end_zone_area_entered(area):
	var enemy = area.get_parent()
	
	if enemy.has_method("take_damage"):
		player_health -= 1
		update_health_ui()
		
		enemies_alive -= 1
		enemy.queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"): # usually ESC
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	if event is InputEventMouseButton and event.pressed:
		if active_tower == null:
			$UpgradePanel.visible = false

func _on_tower_selected(tower):
	active_tower = tower
	$UpgradePanel.visible = true
	$UpgradePanel.set_tower(tower)
