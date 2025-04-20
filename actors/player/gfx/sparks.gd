extends Area3D

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
var scrape:AudioStreamPlayer = null
var num_bodies:int = 0
const scrape_sounds:Array[String] = [
	"res://actors/player/sounds/scrape0.mp3",
	"res://actors/player/sounds/scrape1.mp3",
	"res://actors/player/sounds/scrape2.mp3",
	"res://actors/player/sounds/scrape3.mp3",
	"res://actors/player/sounds/scrape4.mp3",
]

func sparks_on(_body):
	if num_bodies == 0:
		gpu_particles_3d.emitting = true
		scrape = AudioDriver.play_sfx(self.scrape_sounds.pick_random())
	num_bodies += 1
	
func sparks_off(_body):
	num_bodies -= 1
	if num_bodies == 0:
		gpu_particles_3d.emitting = false
		scrape.stop()
