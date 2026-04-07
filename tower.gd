extends Node2D

@export var attack_delay = 1.0
@export var damage = 1

var enemies_in_range = []
var attack_timer = 0.0

func _on_detection_area_area_entered(area):
	var enemy = area.get_parent()
	
	print("ENTERED:", enemy)
	
	if enemy.has_method("take_damage") and not enemies_in_range.has(enemy):
		enemies_in_range.append(enemy)

func _on_detection_area_area_exited(area):
	var enemy = area.get_parent()
	
	if enemy in enemies_in_range:
		enemies_in_range.erase(enemy)

func _process(delta):
	if enemies_in_range.size() > 0:
		attack_timer -= delta
		
		if attack_timer <= 0:
			
			var enemy = enemies_in_range[0]
			
			if not is_instance_valid(enemy):
				enemies_in_range.remove_at(0)
				return
			
			print("ATTACKING")
			attack(enemy)
			
			attack_timer = attack_delay

func attack(enemy):
	if enemy != null:
		enemy.take_damage(1)

# Delay to shoot when placed
func _ready():
	attack_timer = attack_delay
