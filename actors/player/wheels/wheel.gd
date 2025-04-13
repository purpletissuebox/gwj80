extends RayCast3D

@export var car: ShoppingCart

var previous_spring_length: float = 0.0
var is_front_wheel: bool = false
var world_velocity:Vector3 = Vector3.ZERO

func _ready():
	add_exception(car)
	self.is_front_wheel = self in car.front_wheels

func _physics_process(delta):
	if !is_colliding():
		return
	
	self.world_velocity = car.get_wheel_velocity(self)
	var world_collision_point:Vector3 = get_collision_point()
	var v:Vector3 = Vector3.ZERO
	v += engine()
	v += brake()
	v += steer(delta)
	v += suspension(delta, world_collision_point)
	car.apply_force(v, world_collision_point - car.global_position)

func steer(delta):
	var rightwards: Vector3 = self.global_basis.x
	
	var lateral_vel: float = rightwards.dot(self.world_velocity)
	var grip:float = car.grip_front if self.is_front_wheel else car.grip_rear
	var desired_vel_change: float = -lateral_vel * grip
	var friction_force:float = desired_vel_change / delta
	
	return friction_force*rightwards
	
func brake():
	var backwards: Vector3 = self.global_basis.z
	var brake_force:float = backwards.dot(self.world_velocity) * car.mass / 10
	
	return brake_force*backwards*-1
	
func engine():
	if self.is_front_wheel:
		return Vector3.ZERO
	
	var forwards:Vector3 = -(self.global_basis.z)
	var thrust_force:float = car.desired_thrust * car.engine_strength
	
	return thrust_force*forwards

func suspension(delta, collision_point):
	var upwards:Vector3 = self.global_basis.y
	
	var d:float = self.global_position.distance_to(collision_point)
	var curr_spring_length:float = clamp(d - car.wheel_radius, 0, car.rest_height)
	var spring_force:float = car.spring_strength * (car.rest_height - curr_spring_length)
	
	var spring_velocity:float = (curr_spring_length - previous_spring_length) / delta
	var damping_force:float = car.damping * spring_velocity
	var suspension_force:float = spring_force - damping_force
	
	self.previous_spring_length = curr_spring_length
	return upwards*suspension_force
	
	var fender_pos:Vector3 = collision_point + Vector3(0, car.wheel_radius, 0)
	
	car.apply_force(upwards * suspension_force, fender_pos - car.global_position)
