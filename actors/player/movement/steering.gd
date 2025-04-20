extends Node

@export var car:ShoppingCart

var num_wheels:int
var dir:float = 1

func _ready():
	self.num_wheels = car.wheels.size()

func _physics_process(_delta: float) -> void:
	steer()
	friction()

func friction():
	var rightward:Vector3 = car.global_basis.z
	var sideways_vel:float = car.linear_velocity.dot(rightward)
	var strength:float = sideways_vel*car.wheel_grip*-1
	strength *= car.num_wheels_colliding()/car.wheels.size()
	
	car.apply_force_relative(rightward*strength, car.center_of_mass + Vector3(0,-0.05,0))

func steer():
	var forward_vel:float = car.linear_velocity.dot(car.global_basis.x)
	var upward:Vector3 = car.global_basis.y
	var input:float = Input.get_axis("ui_right", "ui_left")
	var ratio:float = forward_vel/car.top_speed
	var steer_efficiency:float = car.steer_curve.sample(abs(ratio))
	var desired_steer_rate:float = steer_efficiency*car.max_steer_rate*input
	var current_steer_rate:float = car.angular_velocity.dot(upward)
	var del:float = desired_steer_rate - current_steer_rate
	var strength:float = car.steer_strength*del*car.num_wheels_colliding()/car.wheels.size()
	car.apply_torque(upward*strength)
