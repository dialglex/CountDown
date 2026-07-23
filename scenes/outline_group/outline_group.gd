class_name OutlineGroup
extends CanvasGroup


func set_on(on: bool) -> void:
	material.set_shader_parameter("on", on);


func _ready() -> void:
	_update_scale()


func _process(_delta: float) -> void:
	_update_scale()


func _update_scale() -> void:
	material.set_shader_parameter("scale", get_viewport_transform().get_scale().x);
