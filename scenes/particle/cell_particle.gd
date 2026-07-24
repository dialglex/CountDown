class_name CellParticle
extends GPUParticles2D


func set_particle_scale(particle_scale: float) -> void:
	particle_scale *= 0.75
	scale = Vector2.ONE*particle_scale
	(process_material as ParticleProcessMaterial).scale_min = particle_scale/2.0
	(process_material as ParticleProcessMaterial).scale_max = particle_scale


func set_color(color: Color) -> void:
	((process_material as ParticleProcessMaterial).color_ramp as GradientTexture1D).gradient.colors = [color]


func _ready() -> void:
	emitting = true


func _on_finished() -> void:
	queue_free()
