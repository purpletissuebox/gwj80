class_name ShoppingCart extends RigidBody3D

@export var friction:float = -0.01

@export_group("Suspension")
@export var rest_height:float = 0.5
@export var spring_strength:float = 10
@export var spring_dampening:float = 1.0
@export var wheel_radius:float = 0.3

@export_group("Engine")
@export var engine_curve:Curve
@export var top_speed:float = 10
@export var engine_strength:float = 3

@export_group("Steering")
@export var grip_curve:Curve
@export var steer_strength:float = 0.02

func get_wheel_speed(w:Wheel):
	return self.linear_velocity + self.angular_velocity.cross(w.global_position - self.global_position)
