class_name World
extends Node


#@onready var _cell_outline_group: OutlineGroup = $CellOutlineGroup
#@onready var _projectile_outline_group: OutlineGroup = $ProjectileOutlineGroup
@onready var _particle_outline_group: OutlineGroup = $ParticleOutlineGroup
@onready var _food_outline_group: OutlineGroup = $FoodOutlineGroup
@onready var _explosion_outline_group: OutlineGroup = $ExplosionOutlineGroup
#
#
#func add_cell(cell: Cell) -> void:
	#_cell_outline_group.add_child(cell)
#
#
#func add_projectile(projectile: Node2D) -> void:
	#_projectile_outline_group.add_child(projectile)


func add_particle(particle: Node2D) -> void:
	_particle_outline_group.add_child(particle)


func add_explosion(explosion: Node2D) -> void:
	_explosion_outline_group.add_child(explosion)


func add_food(food: Node2D) -> void:
	_food_outline_group.add_child(food)
