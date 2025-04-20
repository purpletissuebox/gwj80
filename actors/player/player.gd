class_name ShoppingCart extends RigidBody3D

@export var spring_strength:float = 30
@export var damping:float = 1
@export var engine_curve:Curve
@export var steer_curve:Curve
@export var top_speed:float = 100
@export var zero_to_sixty:float = 1.0
@export var brake_strength:float = 2.0
@export var wheel_grip:float = 40
@export var steer_strength:float = 12
@export_range(0,360,1,"radians_as_degrees") var max_steer_rate:float = PI
@export var wheels:Array[RayCast3D]

var engine_power:float
var engine_sound:AudioStreamPlayer = null
const engine_sounds:Array[String] = [
	"res://actors/player/sounds/drive0.mp3",
	"res://actors/player/sounds/drive1.mp3",
	"res://actors/player/sounds/drive2.mp3",
]

func _ready():
	SignalBus.register_player_cam.emit($Camera3D)
	var acc = 0
	for i in 100:
		acc += self.engine_curve.sample(i/100.0)
	self.engine_power = (top_speed/zero_to_sixty)/(acc/100)

func _physics_process(delta: float) -> void:
	var ratio = abs(self.global_basis.x.dot(self.linear_velocity)/self.top_speed)
	if engine_sound:
		engine_sound.volume_linear = ratio
		if ratio <= 0.3:
			engine_sound.stop()
			engine_sound = null
	else:
		if ratio > 0.3:
			engine_sound = AudioDriver.play_sfx(engine_sounds.pick_random(), 0)
	

func apply_force_relative(force:Vector3, lcl_pos:Vector3):
	var myrotation:Transform3D = self.global_transform
	var end_position:Vector3 = myrotation*lcl_pos
	self.apply_force(force, end_position - self.global_position)

func num_wheels_colliding():
	var acc:int = 0
	for w in self.wheels:
		acc += 1 if w.is_colliding() else 0 #you can access nonexistent members on classes but cant add bool + int. weak.
	return acc

func get_average_floor_normal():
	var acc:Vector3 = Vector3.ZERO
	for w in self.wheels:
		if w.is_colliding():
			acc += w.get_collision_normal()
	return (acc/self.wheels.size()).normalized()
