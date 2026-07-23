class_name Bullet
extends Node2D


const _VELOCITY = 1000.0
var _direction: Vector2
var _damage := 1


func init(direction: Vector2) -> void:
	_direction = direction


func _physics_process(delta: float) -> void:
	position += _direction*_VELOCITY*delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	var enemy := body as Enemy
	enemy.damage(_damage)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
