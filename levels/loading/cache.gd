extends CanvasLayer

signal all_done

@export var emitter:GPUParticles3D

const shaders:Array[ParticleProcessMaterial] = [
	preload("res://levels/loading/particles/crash.tres"),
	preload("res://levels/loading/particles/dollars.tres"),
	preload("res://levels/loading/particles/sparks.tres")
]

const N = 16
var material:int = -1
var frame:int = N-1

func _process(_delta):
	if material == self.shaders.size():
		return
	frame += 1
	frame &= N-1
	if frame == 0:
		render_mat(material)
		material += 1
		if material == self.shaders.size():
			self.all_done.emit()

func render_mat(i):
	emitter.process_material = self.shaders[i]
	emitter.emitting = true
	
