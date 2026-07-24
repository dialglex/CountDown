class_name CellPopup
extends MarginContainer


const _SCALE_SPEED = 25.0
var _open := false
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _name_label: Label = %NameLabel
@onready var _description_label: Label = %DescriptionLabel
@onready var _cooldown_label: Label = %CooldownLabel


func set_display_name(display_name: String) -> void:
	_name_label.text = display_name + " Cell"


func set_description(description: String) -> void:
	_description_label.text = description


func set_divide_cooldown(cooldown: float) -> void:
	_cooldown_label.text = "Mitosis every " + str(cooldown) + "s"


func open() -> void:
	_open = true
	_animation_player.stop()
	_animation_player.play("animation")


func close() -> void:
	_open = false
	_animation_player.stop(true)


func _ready() -> void:
	scale = Vector2.ZERO


func _process(delta: float) -> void:
	if not _animation_player.is_playing():
		var target_scale: Vector2
		if _open:
			target_scale = Vector2.ONE
		else:
			target_scale = Vector2.ZERO
		scale = lerp(scale, target_scale, 1.0 - exp(-_SCALE_SPEED*delta))
	visible = scale.x > 0.25
