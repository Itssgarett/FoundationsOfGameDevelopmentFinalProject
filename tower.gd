extends Node2D

@export var bullet_scene: PackedScene
@export var attack_delay = 0.5
@export var damage = 1

var current_target = null
var enemies_in_range = []
var attack_timer = 0.0

func _on_detection_area_area_entered(area):
	var enemy = area.get_parent()

	if enemy.has_method("take_damage") and not enemies_in_range.has(enemy):
		enemies_in_range.append(enemy)

func _on_detection_area_area_exited(area):
	var enemy = area.get_parent()
	
	if enemy in enemies_in_range:
		enemies_in_range.erase(enemy)
	
	if enemy == current_target:
		current_target = null

func _process(delta):
	if enemies_in_range.size() > 0:
		attack_timer -= delta
		
		# Clean invalid enemies
		enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
		
		# If no target OR target is dead → pick new one
		if current_target == null or not is_instance_valid(current_target):
			if enemies_in_range.size() > 0:
				current_target = enemies_in_range[0]
			else:
				current_target = null
		
		if current_target != null and attack_timer <= 0:
			attack(current_target)
			attack_timer = attack_delay

func attack(enemy):
	if enemy != null:
		look_at(enemy.global_position)
		
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.target = enemy
		
		get_tree().current_scene.add_child(bullet)

func _ready():
	attack_timer = attack_delay
