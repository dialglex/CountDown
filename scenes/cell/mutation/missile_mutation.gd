class_name MissileMutation
extends MutationEntity


var _missile_scene := preload("res://scenes/missile/missile.tscn")


func _on_timer_timeout() -> void:
	var missile := _missile_scene.instantiate() as Missile
	missile.init(size)#, Mutation.stats[Mutation.Id.MISSILE].color, Mutation.stats[Mutation.Id.MISSILE].nucleus_color)
	missile.position = global_position
	get_tree().current_scene.add_child(missile)
