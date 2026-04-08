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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_money_ui()
	spawn_rounds()

func spawn_rounds():
	while true: 
		print("Round ", current_round)
		
		await spawn_round(enemies_per_round)
		current_round += 1
		enemies_per_round += 5
		
		await get_tree().create_timer(3.0).timeout

func spawn_round(amount):
	for i in range(amount):
		spawn_enemy()
		await get_tree().create_timer(0.5).timeout
		
func spawn_enemy():
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
	if selected_tower ==1:
		tower = tower_scene.instantiate()
	else:
		tower = tower_scene2.instantiate()
	tower.position = pos
	add_child(tower)
	
func is_on_path(position):
	var tilemap = $TileMap   # change name if needed
	
	var cell = tilemap.local_to_map(tilemap.to_local(position))
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


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
