class_name ShooterMutation
extends MutationEntity


var _bullet_scene := preload("res://scenes/bullet/bullet.tscn")
@onready var _shoot_component: ShootComponent = $ShootComponent


func _on_timer_timeout() -> void:
	var direction := _shoot_component.get_shoot_direction()
	if direction == Vector2.ZERO:
		return
	var bullet := _bullet_scene.instantiate() as Bullet
	bullet.init(size, direction, Mutation.stats[Mutation.Id.SHOOTER].color, Mutation.stats[Mutation.Id.SHOOTER].nucleus_color)
	bullet.position = global_position
	get_tree().current_scene.add_child(bullet)
