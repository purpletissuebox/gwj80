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

func _process(delta):
	self.desired_thrust = Input.get_axis("brake", "gas_pedal")
	var desired_angle = Input.get_axis("turn_right", "turn_left") * self.max_angle
	
	for w in self.front_wheels:
		w.rotation.y = lerp(w.rotation.y, desired_angle, 5*delta)

func get_wheel_velocity(w:Node3D):
	return self.linear_velocity + self.angular_velocity.cross(w.global_position - self.global_position)
