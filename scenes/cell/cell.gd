class_name Cell
extends RigidBody2D


const _MIN_SIZE = 96.0
const _ACCELERATION = 800.0
const _DIVIDE_VELOCITY = 400.0
static var food_amount := 0
var _cell_scene := preload("res://scenes/cell/cell.tscn")
var _bullet_scene := preload("res://scenes/bullet/bullet.tscn")
var _size := 8
var _hovered := false
@onready var _outline_group: OutlineGroup = $OutlineGroup
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _label: Label = $Label
@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _mouse_shape: CollisionShape2D = %MouseShape
@onready var _enemy_area: Area2D = $EnemyArea


func init(size: int) -> void:
	_size = size


func get_size() -> int:
	return _size


func damage(amount: int) -> void:
	_size -= amount
	if _size <= 0:
		queue_free()
	_update_size()


func _ready() -> void:
	_update_size()


func _physics_process(_delta: float) -> void:
	apply_force(position.direction_to(Vector2(1920, 1080)/2)*_ACCELERATION)


func _update_size() -> void:
	if _size <= 0:
		return
	_label.text = str(_size)
	(_sprite.texture as GradientTexture2D).width = round(_MIN_SIZE*sqrt(_size))
	(_sprite.texture as GradientTexture2D).height = round(_MIN_SIZE*sqrt(_size))
	(_collision_shape.shape as CircleShape2D).radius = (_MIN_SIZE/2.0)*sqrt(_size)*0.75
	(_mouse_shape.shape as CircleShape2D).radius = (_MIN_SIZE/2.0)*sqrt(_size)*0.75


func _shoot() -> void:
	var enemies := _enemy_area.get_overlapping_bodies()
	if enemies.is_empty():
		return
	var min_distance := INF
	var closest_position: Vector2
	for enemy: Enemy in enemies:
		var curr_distance := position.distance_squared_to(enemy.position)
		if curr_distance < min_distance:
			closest_position = enemy.position
	var bullet := _bullet_scene.instantiate() as Bullet
	bullet.init(position.direction_to(closest_position))
	bullet.position = position
	get_tree().current_scene.add_child(bullet)


func _divide() -> void:
	if _size > 1:
		var cell_1 := _cell_scene.instantiate() as Cell
		var cell_2 := _cell_scene.instantiate() as Cell
		var cell_1_size := _size/2
		var cell_2_size := _size/2
		if _size % 2 == 1:
			cell_1_size += 1
		cell_1.init(cell_1_size)
		cell_2.init(cell_2_size)
		var angle := randf_range(0.0, PI)
		cell_1.linear_velocity = -Vector2.from_angle(angle)*_DIVIDE_VELOCITY
		cell_2.linear_velocity = Vector2.from_angle(angle)*_DIVIDE_VELOCITY
		cell_1.position = position
		cell_2.position = position
		get_tree().current_scene.add_child(cell_1)
		get_tree().current_scene.add_child(cell_2)
	queue_free()


func _on_shoot_timer_timeout() -> void:
	_shoot()


func _on_divide_timer_timeout() -> void:
	_divide()


func _on_mouse_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if food_amount == 0:
		return
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if mouse_button_event.pressed and mouse_button_event.button_index == 1:
			_size += 1
			_update_size()
			food_amount -= 1
			var hud := get_tree().get_first_node_in_group("hud") as HUD
			hud.set_food_amount(food_amount)


func _on_area_2d_mouse_entered() -> void:
	_hovered = true
	_outline_group.set_on(true)
	z_index = 1


func _on_mouse_area_mouse_exited() -> void:
	_hovered = false
	_outline_group.set_on(false)
	z_index = 0
