class_name HUD
extends Control


@onready var _food_label: Label = %FoodLabel


func set_food_amount(food_amount: int) -> void:
	_food_label.text = "Food: " + str(food_amount)
