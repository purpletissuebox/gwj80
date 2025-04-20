extends RayCast3D

@export var car:ShoppingCart
@onready var sparks:GPUParticles3D = $Area3D/GPUParticles3D
const crash_sounds:Array[String] = [
	"res://actors/player/sounds/impact0.mp3",
	"res://actors/player/sounds/impact1.mp3",
	"res://actors/player/sounds/impact2.mp3",
	"res://actors/player/sounds/impact3.mp3",
	"res://actors/player/sounds/impact4.mp3",
]

var length:float

func _ready() -> void:
	self.length = self.target_position.length()
	self.add_exception(car)
	
func _physics_process(_delta: float) -> void:
	if self.is_colliding():
		car.apply_force_relative(spring_force(), self.position + car.center_of_mass)

func spring_force():
	var hit_length:float = (self.global_position - self.get_collision_point()).length()
	var compression:float = 1 - hit_length/self.length
	
	var velocity:Vector3 = car.linear_velocity + car.angular_velocity.cross(self.global_position - car.global_position)
	var upward:Vector3 = self.global_basis.y
	var upwards_vel:float = velocity.dot(upward)
	
	return upward*(compression*car.spring_strength - upwards_vel*car.damping)

func do_sparks(_body):
	sparks.emitting = true
	AudioDriver.play_sfx(self.crash_sounds.pick_random(), 0.4)
	
