class_name Missile
extends Node2D


const _ACCELERATION = 3000.0
const _MAX_SPEED = 1500.0
const _BOOST_SPEED = 1500.0
var _velocity: Vector2
var _size := 1
var _damage := 1
var _explosion_scene := preload("res://scenes/explosion/explosion.tscn")
@onready var _particles: GPUParticles2D = %GPUParticles2D


func init(size: int) -> void:
	_size = size
	_velocity = Vector2.from_angle(randf_range(0.0, 2.0*PI))*_BOOST_SPEED


func _ready() -> void:
	scale = Vector2.ONE*sqrt(_size)
	(_particles.process_material as ParticleProcessMaterial).scale_max = sqrt(_size)/3.0
	_particles.lifetime = 0.06*sqrt(_size)


func _physics_process(delta: float) -> void:
	var target_position := _get_closest_enemy_position()
	if target_position != Vector2.INF:
		_velocity = (_velocity + position.direction_to(target_position)*_ACCELERATION*delta).limit_length(_MAX_SPEED)
	position += _velocity*delta
	rotation = _velocity.angle()


func _get_closest_enemy_position() -> Vector2:
	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		return Vector2.INF
	var min_distance := INF
	var closest_position: Vector2
	for enemy: Enemy in enemies:
		var curr_distance := global_position.distance_squared_to(enemy.position)
		if curr_distance < min_distance:
			closest_position = enemy.position
	return closest_position


func _on_area_2d_body_entered(_body: Node2D) -> void:
	var explosion := _explosion_scene.instantiate() as Explosion
	explosion.position = global_position
	explosion.init(1)
	(get_tree().current_scene as World).add_explosion.call_deferred(explosion)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
