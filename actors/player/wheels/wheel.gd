class_name Wheel extends RayCast3D

@export var car_body:ShoppingCart
@export var back_tire:bool
@export_range(0,100,1) var suspension_strength:float
@export_range(0,1,0.01) var suspension_damping:float
@export var steer_force:Curve
@export var engine_force:Curve

@onready var visual_r: RayCast3D = $right
@onready var visual_g: RayCast3D = $up
@onready var visual_b: RayCast3D = $fwd

var velocity:Vector3
var g_position:Vector3
var orientation:Basis

func _physics_process(delta):
	if !self.is_colliding():
		self.visual_g.target_position = Vector3.ZERO
		self.visual_b.target_position = Vector3.ZERO
		self.visual_r.target_position = Vector3.ZERO
		return
	
	self.velocity = self.car_body.get_wheel_speed(self)
	self.orientation = get_global_transform().basis
	self.g_position = get_global_position()
	
	var v:Vector3 = Vector3.ZERO
	self.visual_g.target_position = self.suspension().length()*Vector3.UP
	self.visual_b.target_position = self.engine().length()*Vector3.FORWARD
	self.visual_r.target_position = self.steer(delta).length()*Vector3.RIGHT
	
	v += self.suspension()
	v += self.engine()
	v += self.steer(delta)
	self.car_body.apply_force(v, self.g_position)
	
func suspension():
	var upwards:Vector3 = self.orientation.y
	var free_end:Vector3 = self.g_position + self.target_position
	var col = self.get_collision_point()
	var sink_length:float = (self.get_collision_point() - free_end).length()
	
	var spring_force = sink_length*self.suspension_strength
	var damp_force = self.velocity.dot(upwards)*self.suspension_damping
	
	return upwards*(spring_force - damp_force)

func steer(delta):
	return Vector3.ZERO
	var amount = Input.get_axis("turn_right", "turn_left")
	if !self.back_tire:
		self.rotation.y = move_toward(self.rotation.y, amount*PI/8, delta*PI/4)
		
	var rightward = self.orientation.z
	var slide_speed:float = self.velocity.dot(rightward)
	var slide_ratio:float = slide_speed/self.velocity.length()
	var grip_factor:float = self.steer_force.sample(slide_ratio)
	var grip_speed_change:float = slide_speed*grip_factor*-1
	var grip_acceleration:float = grip_speed_change/delta
	return rightward*grip_acceleration

func engine():
	return Vector3.ZERO
	var amount = Input.get_axis("brake", "gas_pedal")
	var forwards:Vector3 = self.orientation.x
	
	var car_speed:float = self.car_body.linear_velocity.dot(self.car_body.global_basis.x)
	var norm_speed:float = abs(car_speed)/300
	var power = self.engine_force.sample(norm_speed)
	return forwards*power*amount
