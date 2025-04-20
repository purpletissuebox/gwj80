extends Area3D

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


func sparks_on(_body):
	gpu_particles_3d.emitting = true
	
func sparks_off(_body):
	gpu_particles_3d.emitting = false
