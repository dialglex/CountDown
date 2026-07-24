class_name Explosion
extends Node2D


const _ANIMATION_SPEED = 15
var _progress := 0.0
var _radius := 128
var _size: int
var _damage: int
@onready var _sprite := %Sprite2D
@onready var _collision_shape := %CollisionShape2D


func init(damage: int) -> void:
	_size = _radius*2
	_damage = damage


func _ready() -> void:
	_sprite.texture.width = _radius*2
	_sprite.texture.height = _radius*2


func _process(delta: float) -> void:
	_progress = lerp(_progress, 1.0, 1.0 - exp(-_ANIMATION_SPEED*delta))
	
	_sprite.material.set_shader_parameter("progress", _progress)
	_collision_shape.shape.radius = max(0, _radius*_progress)
	if _progress >= 0.998:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var enemy := body as Enemy
	enemy.damage(_damage)
