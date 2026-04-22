extends Control

var tower = null

func set_tower(t):
	tower = t

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_upgrade_damage_pressed():
	if tower:
		tower.upgrade_damage()

func _on_upgrade_range_pressed():
	if tower:
		tower.upgrade_range()

func _on_sell_pressed():
	if tower:
		tower.queue_free()
		visible = false
