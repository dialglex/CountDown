class_name MutationStats
extends Resource


@export var id := Mutation.Id.NONE
@export var scene: PackedScene
@export var possible_mutations: Array[Mutation.Id]
@export var color: Color
@export var nucleus_color: Color
@export var display_name: String
@export_multiline var description: String
@export var cooldown := 4.0
