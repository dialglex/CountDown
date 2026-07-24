extends Node


var _enemy_scene := preload("res://scenes/enemy/enemy.tscn")
@export var _outline_group: OutlineGroup


func _on_timer_timeout() -> void:
	var enemy := _enemy_scene.instantiate() as Enemy
	while true:
		var position := Vector2(randf_range(0 - 256, 1920 + 256), randf_range(0 - 256, 1080 + 256))
		if position.x < 0 or position.x > 1920 or position.y < 0 or position.y > 1080:
			enemy.position = position
			break
	_outline_group.add_child(enemy)
