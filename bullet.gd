extends Node2D

var speed = 400
var target = null

func _process(delta):
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
		
		rotation = direction.angle() + deg_to_rad(90)
		
		if global_position.distance_to(target.global_position) < 10:
			target.take_damage(1)
			queue_free()
	else:
		queue_free()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
