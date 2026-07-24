class_name TackMutation
extends MutationEntity


var _bullet_scene := preload("res://scenes/bullet/bullet.tscn")


func _on_timer_timeout() -> void:
	for i in range(8):
		var bullet := _bullet_scene.instantiate() as Bullet
		bullet.init(size, Vector2.from_angle((i/8.0)*2*PI), Mutation.stats[Mutation.Id.TACK].color, Mutation.stats[Mutation.Id.TACK].nucleus_color)
		bullet.position = global_position
		get_tree().current_scene.add_child(bullet)
