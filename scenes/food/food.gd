extends Node2D


const _TARGET_POSITION = Vector2(48, 60)
var _lerping := false


func start_lerp() -> void:
	_lerping = true


func _physics_process(delta: float) -> void:
	if _lerping:
		position = position.lerp(_TARGET_POSITION, 1.0 - exp(-5.0*delta))
	if position.distance_to(_TARGET_POSITION) < 8.0:
		Cell.food_amount += 1
		var hud := get_tree().get_first_node_in_group("hud") as HUD
		hud.update_food_amount()
		queue_free()
