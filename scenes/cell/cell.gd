class_name Cell
extends RigidBody2D


const _MIN_SIZE = 64.0
const _ACCELERATION = 1000.0
const _PUSH_ACCELERATION = 1000000.0
const _DIVIDE_VELOCITY = 400.0
const _DRAG_SPEED = 10.0
const _SHAKE_AMPLITUDE = 8.0
const _SHAKE_SPEED = 15.0
static var food_amount := 0
static var held := false
var _self_held := false
var _cell_scene := preload("res://scenes/cell/cell.tscn")
var _particle_scene := preload("res://scenes/particle/cell_particle.tscn")
var _size := 8
var _mutation_id := Mutation.Id.MISSILE
var _mutation: MutationEntity
var _hover := false
@onready var _outline_group: OutlineGroup = %OutlineGroup
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _label: Label = %Label
@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _mouse_shape: CollisionShape2D = %MouseShape
@onready var _popup: CellPopup = %Popup
@onready var _popup_control: Control = %PopupControl
@onready var _divide_timer: Timer = $DivideTimer


func init(size: int, mutation_id: Mutation.Id) -> void:
	_mutation_id = mutation_id
	_size = size


func get_size() -> int:
	return _size


func damage(amount: int) -> void:
	_size -= amount
	if _size <= 0:
		queue_free()
	_update_size()


func _ready() -> void:
	_mutation = Mutation.stats[_mutation_id].scene.instantiate()
	add_child(_mutation)
	_update_size()
	_sprite.material.set_shader_parameter("seed", randf()*1000.0)
	_sprite.material.set_shader_parameter("direction", randf_range(-1.0, 1.0))
	_popup.set_display_name(Mutation.stats[_mutation_id].display_name)
	_popup.set_description(Mutation.stats[_mutation_id].description)
	_popup.set_divide_cooldown(Mutation.stats[_mutation_id].cooldown)
	_sprite.material.set_shader_parameter("color", Mutation.stats[_mutation_id].color)
	_sprite.material.set_shader_parameter("nucleus_color", Mutation.stats[_mutation_id].nucleus_color)
	_divide_timer.start(Mutation.stats[_mutation_id].cooldown)


func _process(_delta: float) -> void:
	_popup_control.global_position = position + Vector2.DOWN*(_MIN_SIZE/2.0)*sqrt(_size)*1.5
	var divide_progress := (1.0 - _divide_timer.time_left/_divide_timer.wait_time)
	var shake_amplitude := exp(_SHAKE_SPEED*(divide_progress - 1.0))*_SHAKE_AMPLITUDE
	_sprite.position = Vector2(randf_range(-shake_amplitude, shake_amplitude), randf_range(-shake_amplitude, shake_amplitude))


func _physics_process(delta: float) -> void:
	if _self_held:
		position = position.lerp(get_viewport().get_mouse_position(), 1.0 - exp(-_DRAG_SPEED*delta))
		linear_velocity = Vector2.ZERO
	else:
		apply_force(position.direction_to(Vector2(1920, 1080)/2)*_ACCELERATION)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if held and not mouse_button_event.pressed and mouse_button_event.button_index == 1:
			held = false
			_self_held = false
			if _hover:
				_popup.open()
		elif _hover and mouse_button_event.pressed and mouse_button_event.button_index == 2:
			if food_amount == 0:
				return
			_size += 1
			_update_size()
			food_amount -= 1
			var hud := get_tree().get_first_node_in_group("hud") as HUD
			hud.update_food_amount()


func _update_size() -> void:
	if _size <= 0:
		return
	_label.text = str(_size)
	(_sprite.texture as GradientTexture2D).width = round(_MIN_SIZE*sqrt(_size)*1.25)
	(_sprite.texture as GradientTexture2D).height = round(_MIN_SIZE*sqrt(_size)*1.25)
	(_collision_shape.shape as CircleShape2D).radius = (_MIN_SIZE/2.0)*sqrt(_size)*1.0
	(_mouse_shape.shape as CircleShape2D).radius = (_MIN_SIZE/2.0)*sqrt(_size)*1.0
	_mutation.size = _size


func _divide() -> void:
	if _size > 1:
		var cell_1 := _cell_scene.instantiate() as Cell
		var cell_2 := _cell_scene.instantiate() as Cell
		var cell_1_size := _size/2
		var cell_2_size := _size/2
		if _size % 2 == 1:
			cell_1_size += 1
		cell_1.init(cell_1_size, Mutation.stats[_mutation_id].possible_mutations.pick_random())
		cell_2.init(cell_2_size, Mutation.stats[_mutation_id].possible_mutations.pick_random())
		var angle := randf_range(0.0, PI)
		cell_1.linear_velocity = -Vector2.from_angle(angle)*_DIVIDE_VELOCITY
		cell_2.linear_velocity = Vector2.from_angle(angle)*_DIVIDE_VELOCITY
		cell_1.position = position
		cell_2.position = position
		get_parent().add_child(cell_1)
		get_parent().add_child(cell_2)
	_add_particle()
	queue_free()


func _add_particle() -> void:
	var particle := _particle_scene.instantiate() as CellParticle
	particle.position = position
	particle.set_particle_scale(sqrt(_size))
	particle.set_color(Mutation.stats[_mutation_id].color)
	(get_tree().current_scene as World).add_particle(particle)


func _set_hover(hover: bool) -> void:
	_hover = hover
	_outline_group.set_on(hover)
	_outline_group.visible = hover


func _on_divide_timer_timeout() -> void:
	_divide()


func _on_mouse_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if mouse_button_event.pressed:
			if mouse_button_event.button_index == 1:
				held = true
				_self_held = true
				_popup.close()


func _on_mouse_area_mouse_entered() -> void:
	_set_hover(true)
	if not held:
		_popup.open()


func _on_mouse_area_mouse_exited() -> void:
	_set_hover(false)
	if not held:
		_popup.close()
