extends Node2D

@export var enemy_scene: PackedScene

var enemies_alive = 0
var current_round = 1 
var enemies_per_round = 5 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	var enemy = enemy_scene.instantiate()
	$Path2D.add_child(enemy)
	enemies_alive +=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
