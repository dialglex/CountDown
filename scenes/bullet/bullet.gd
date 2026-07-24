class_name Bullet
extends Node2D


const _VELOCITY = 1000.0
var _direction: Vector2
var _size := 1
var _damage := 1
var _color := Color(1, 1, 1, 1)
var _nucleus_color := Color(1, 1, 1, 1)
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: GPUParticles2D = %GPUParticles2D


func init(size: int, direction: Vector2, color: Color, nucleus_color: Color) -> void:
	_size = size
	_direction = direction
	_color = color
	_nucleus_color = nucleus_color


func _ready() -> void:
	scale = Vector2.ONE*sqrt(_size)
	(_particles.process_material as ParticleProcessMaterial).scale_max = sqrt(_size)/3.0
	_particles.lifetime = 0.06*sqrt(_size)
	_sprite.material.set_shader_parameter("color", _color)
	_sprite.material.set_shader_parameter("nucleus_color", _nucleus_color)
	((_particles.process_material as ParticleProcessMaterial).color_ramp as GradientTexture1D).gradient.colors = [_color]


func _physics_process(delta: float) -> void:
	position += _direction*_VELOCITY*delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	var enemy := body as Enemy
	enemy.damage(_damage)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
