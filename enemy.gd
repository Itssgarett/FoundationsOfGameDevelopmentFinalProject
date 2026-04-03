extends PathFollow2D

@export var speed = 100

var health = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += speed * delta

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()
