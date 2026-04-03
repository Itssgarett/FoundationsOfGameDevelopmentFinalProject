extends Node2D

var enemies_in_range = []

func _on_area_2d_body_entered(body):
	if body is PathFollow2D:
		enemies_in_range.append(body)

func _on_area_2d_body_exited(body):
	if body in enemies_in_range:
		enemies_in_range.erase(body)

func _process(delta):
	if enemies_in_range.size() > 0:
		attack(enemies_in_range[0])

func attack(enemy):
	if enemy != null:
		enemy.take_damage(1)
		
