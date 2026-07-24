class_name HUD
extends Control


@onready var _food_label: Label = %FoodLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func update_food_amount() -> void:
	_food_label.text = "Food: " + str(Cell.food_amount)
	_animation_player.stop()
	_animation_player.play("food")
