class_name Enemy
extends RigidBody2D


const _MIN_SIZE = 64.0
const _VELOCITY = 50.0
var _size := 1
var _food_scene := preload("res://scenes/food/food.tscn")
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _label: Label = $Label
@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _cell_shape: CollisionShape2D = %CellShape


func init(size: int) -> void:
	_size = size


func damage(amount: int) -> void:
	_size -= amount
	if _size <= 0:
		queue_free()
		var food := _food_scene.instantiate()
		food.position = position
		(get_tree().current_scene as World).add_food(food)
	_update_size()


func _ready() -> void:
	_update_size()


func _physics_process(_delta: float) -> void:
	linear_velocity = position.direction_to(Vector2(1920, 1080)/2)*_VELOCITY


func _update_size() -> void:
	if _size <= 0:
		return
	_label.text = str(_size)
	(_sprite.texture as GradientTexture2D).width = round(_MIN_SIZE*sqrt(_size))
	(_sprite.texture as GradientTexture2D).height = round(_MIN_SIZE*sqrt(_size))
	(_collision_shape.shape as CircleShape2D).radius = (_MIN_SIZE/2.0)*sqrt(_size)*0.75
	(_cell_shape.shape as CircleShape2D).radius = (_MIN_SIZE/2.0)*sqrt(_size)*0.75


func _on_cell_area_body_entered(body: Node2D) -> void:
	if _size <= 0:
		return
	var cell := body as Cell
	var damage_amount := mini(_size, cell.get_size())
	damage(damage_amount)
	cell.damage(damage_amount)
