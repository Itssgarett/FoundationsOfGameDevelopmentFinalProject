extends PathFollow2D

@export var speed = 100

var health = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed * delta

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	print("ENEMY DIED")
	
	var level = get_tree().get_first_node_in_group("level")
	if level:
		level.money += 10
		level.update_money_ui()
		
	queue_free()
