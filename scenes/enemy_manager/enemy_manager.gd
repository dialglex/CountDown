extends Node


var _enemy_scene := preload("res://scenes/enemy/enemy.tscn")


func _on_timer_timeout() -> void:
	var enemy := _enemy_scene.instantiate() as Enemy
	while true:
		var position := Vector2(randf_range(0 - 256, 1920 + 256), randf_range(0 - 256, 1080 + 256))
		if position.x < 0 or position.x > 1920 or position.y < 0 or position.y > 1080:
			enemy.position = position
			break
	get_tree().current_scene.add_child(enemy)
