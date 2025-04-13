class_name Cart extends RigidBody3D

@export_category("Suspension")
@export var spring_strength:float = 20
@export var damping_strength:float = 2
@export_category("Engine")
@export var engine_strength:float = 200
@export var top_speed:float = 100
@export var engine_curve:Curve
@export var brake_strength:float = 2
@export_category("Steering")
@export var turn_strength:float = 50
@export var grip_strength:float = 10
@export var damping_factor:float = 8
@export var spin_curve:Curve
@export_range(0,720, 0.01, "radians_as_degrees") var max_spin_rate:float = TAU

@export var center_o_mass:Marker3D
@onready var collider: CollisionShape3D = $MovementHitbox

func _ready():
	self.center_of_mass = self.collider.position

func get_wheel_speed(x:Node3D):
	return self.linear_velocity + self.angular_velocity.cross(x.global_position - self.global_position)
