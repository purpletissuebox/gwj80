class_name Wheel extends RayCast3D

@export var car:ShoppingCart
@export var back_tire:bool
@export var him:bool

@onready var visual_r: RayCast3D = $right
@onready var visual_g: RayCast3D = $up
@onready var visual_b: RayCast3D = $fwd

var spring_len_last_frame:float = 0.0
var velocity:Vector3

func _physics_process(delta):
	if !self.is_colliding():
		self.visual_g.target_position = Vector3.ZERO
		self.visual_b.target_position = Vector3.ZERO
		self.visual_r.target_position = Vector3.ZERO
		return
	
	self.velocity = car.get_wheel_speed(self)
	self.velocity.y = 0
	var v:Vector3 = Vector3.ZERO
	if him:
		print(str(self.velocity) + " " + str(self.velocity.length()))
	#self.visual_g.target_position = self.suspension(delta, 1).length()*Vector3.UP
	#self.visual_b.target_position = self.engine().length()*Vector3.RIGHT
	#self.visual_r.target_position = self.steer(delta).length()*Vector3.BACK
	
	v += self.suspension(delta, 0)
	v += self.engine()
	v += self.brake()
	v += self.steer(delta)
	car.apply_force(v, self.get_collision_point() - car.global_position)

func suspension(delta, debug):
	var upwards:Vector3 = self.global_basis.y
	var ground_distance:float = (self.get_collision_point()).distance_to(self.global_position)
	
	var current_spring_length:float = clamp(ground_distance - car.wheel_radius, 0, car.rest_height)
	var spring_force:float = car.spring_strength * (car.rest_height - current_spring_length)
	var spring_velocity:float = (current_spring_length - self.spring_len_last_frame) / delta
	
	if !debug:
		self.spring_len_last_frame = current_spring_length
	
	var damping_force:float = car.spring_dampening * spring_velocity
	var suspension_force = basis.y * (spring_force - damping_force)
	
	return upwards*suspension_force

func steer(delta):
	if self.velocity.length() < 0.001:
		return Vector3.ZERO
	
	var amount = Input.get_axis("turn_right", "turn_left")
	if !self.back_tire:
		self.rotation.y = move_toward(self.rotation.y, amount*PI/4, delta*PI/4)
	var rightward = self.global_basis.z
	var lateral_speed:float = self.velocity.dot(rightward)
	
	var slide_ratio:float = lateral_speed/self.velocity.length()
	var grip_factor:float = car.grip_curve.sample(slide_ratio)
	var grip_speed_change:float = -lateral_speed*grip_factor
	var grip_acceleration:float = grip_speed_change/delta
	return rightward*grip_acceleration*car.steer_strength

func engine():
	if !self.back_tire:
		return Vector3.ZERO
	
	var amount = Input.get_axis("brake", "gas_pedal")
	var forwards:Vector3 = self.global_basis.x
	
	var car_speed:float = car.linear_velocity.dot(car.global_basis.x)
	var norm_speed:float = abs(car_speed)/car.top_speed
	var power = car.engine_curve.sample(norm_speed)
	return forwards*power*amount*car.engine_strength

func brake():
	var forwards = self.global_basis.x
	var brake_speed = car.get_wheel_speed(self).dot(forwards)
	return forwards*brake_speed*car.friction*-1
