class_name ShootComponent
extends Node2D


func get_shoot_direction() -> Vector2:
	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		return Vector2.ZERO
	var min_distance := INF
	var closest_position: Vector2
	for enemy: Enemy in enemies:
		var curr_distance := global_position.distance_squared_to(enemy.position)
		if curr_distance < min_distance:
			closest_position = enemy.position
	return global_position.direction_to(closest_position)
