class_name FarmerMutation
extends MutationEntity


func _on_timer_timeout() -> void:
	var food := load("res://scenes/food/food.tscn").instantiate() as Node2D
	food.position = global_position
	(get_tree().current_scene as World).add_food(food)
