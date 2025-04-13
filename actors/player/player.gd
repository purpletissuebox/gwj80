class_name ShoppingCart extends RigidBody3D

@export_category("Suspension")
@export var rest_height: float = 0.5
@export var spring_strength: float = 1000
@export var damping: float = 25
@export var wheel_radius: float = 0.3

@export_category("Engine")
@export var engine_strength: float = 100

@export_category("Steering")
@export_range(0,90,1,"radians_as_degrees") var max_angle: float = PI/6
@export var grip_front: float = 1.0
@export var grip_rear: float = 1.5
@export var front_wheels:Array[RayCast3D]

var desired_thrust:float = 0
var prev_vel:Vector3 = Vector3.ZERO
var engine_sound:AudioStreamPlayer = null
var drift_sound:AudioStreamPlayer = null
var sound_cooldown:float = 0.0

func _ready():
	AudioDriver.play_bgm("res://levels/test_shop/bgm.mp3", 0)

func _physics_process(delta):
	if self.sound_cooldown > 0:
		self.sound_cooldown -= delta
		self.prev_vel = self.linear_velocity
		return
	
	if (self.linear_velocity - self.prev_vel).length() > 30.0:
		AudioDriver.play_sfx("res://actors/player/sounds/crash.mp3")
		cancelSound(1)
		cancelSound(0)
		self.sound_cooldown = 1.2
		return
	
	if self.angular_velocity.length() > 3.0 or desired_thrust * self.linear_velocity.dot(-self.global_basis.z) <= -0.1:
		if !drift_sound:
			if self.front_wheels[0].is_colliding() and self.front_wheels[1].is_colliding():
				self.drift_sound = AudioDriver.play_sfx("res://actors/player/sounds/slide.mp3")
	else:
		cancelSound(1)
	
	if self.desired_thrust * self.linear_velocity.dot(-self.global_basis.z) >= 0.1:
		if !engine_sound:
			self.engine_sound = AudioDriver.play_sfx("res://actors/player/sounds/accel.mp3")
	else:
		cancelSound(0)
	
	self.prev_vel = self.linear_velocity

func cancelSound(which:int):
	if which:
		if self.drift_sound:
			self.drift_sound.stop()
			self.drift_sound = null
	else:
		if self.engine_sound:
			self.engine_sound.stop()
			self.engine_sound = null

func _process(delta):
	self.desired_thrust = Input.get_axis("brake", "gas_pedal")
	var desired_angle = Input.get_axis("turn_right", "turn_left") * self.max_angle
	
	for w in self.front_wheels:
		w.rotation.y = lerp(w.rotation.y, desired_angle, 5*delta)

func get_wheel_velocity(w:Node3D):
	return self.linear_velocity + self.angular_velocity.cross(w.global_position - self.global_position)
