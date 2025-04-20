extends Node

@export var car:ShoppingCart

var num_wheels:int

func _ready():
	self.num_wheels = car.wheels.size()

func _physics_process(_delta: float) -> void:
	var fwd_vel:float = car.global_basis.x.dot(car.linear_velocity)
	var input = Input.get_axis("ui_down", "ui_up")
	
	if is_zero_approx(input):
		friction(fwd_vel)
	
	elif fwd_vel*input >= car.top_speed/-20:
		engine(fwd_vel, sign(input))
	else:
		brake(fwd_vel, sign(input))

func friction(velocity:float):
	if !is_zero_approx(velocity):
		push_car(abs(velocity), -sign(velocity), 1)

func engine(velocity:float, direction:float):
	var ratio:float = abs(velocity/car.top_speed)
	var engine_efficiency:float = car.engine_curve.sample(ratio)
	var force = engine_efficiency*car.engine_power
	
	push_car(force, direction, 1-ratio)
	
func brake(velocity:float, direction:float):
	var ratio:float = abs(velocity/car.top_speed)
	push_car(car.engine_power, direction, car.brake_strength*ratio)
	
func push_car(strength:float, direction:float, buckle:float):
	var active_wheels:int = car.num_wheels_colliding()
	if !active_wheels:
		return
	
	var wheel_frac:float = float(active_wheels)/self.num_wheels
	var floor_vector:Vector3 = car.get_average_floor_normal()
	var forward = car.global_basis.x.slide(floor_vector).normalized()
	var slightly_down = Vector3(0,-0.3*buckle,0)
	
	car.apply_force_relative(forward*strength*direction*wheel_frac, car.center_of_mass + slightly_down)
