extends RayCast3D

@export var car:ShoppingCart
@onready var label:Label3D = $Label3D

var length:float

func _ready() -> void:
	self.length = self.target_position.length()
	
func _physics_process(delta: float) -> void:
	if self.is_colliding():
		car.apply_force_relative(spring_force(), self.position + car.center_of_mass)
	else:
		self.label.text = "0.00"

func spring_force():
	var hit_length:float = (self.global_position - self.get_collision_point()).length()
	var compression:float = 1 - hit_length/self.length
	self.label.text = "%0.2f" % compression
	
	var velocity:Vector3 = car.linear_velocity + car.angular_velocity.cross(self.global_position - car.global_position)
	var upward:Vector3 = self.global_basis.y
	var upwards_vel:float = velocity.dot(upward)
	
	return upward*(compression*car.spring_strength - upwards_vel*car.damping)
