extends RayCast3D

@export var car:Cart
@onready var label_3d: Label3D = $Label3D
var raylength:float = 1

func _ready():
	raylength = self.target_position.length()
	self.add_exception(car)

func _physics_process(_delta):
	if !self.is_colliding():
		return
	
	var hitpos:Vector3 = self.get_collision_point()
	var groundslope:Vector3 = self.get_collision_normal()
	var world_speed:Vector3 = car.get_wheel_speed(self)
	
	car.apply_force(suspension(hitpos, world_speed), self.global_position - car.global_position)
	car.apply_force(accelerate(groundslope), car.center_o_mass.global_position - car.global_position)
	car.apply_torque(steer())
	car.apply_force(sliding_friction(), car.collider.global_position - car.global_position)
	
func suspension(hit, world_speed):
	var upward:Vector3 = self.global_basis.y
	var compression:float = 1-((self.global_position - hit).length())/self.raylength
	var vertical_speed:float = upward.dot(world_speed)
	var spring_force:float = compression*car.spring_strength
	var damping_force:float = vertical_speed*car.damping_strength
	
	var result = spring_force - damping_force
	self.label_3d.text = str(compression)
	return upward*result

func accelerate(ground_norm):
	var forward = (-car.global_basis.z).slide(ground_norm)
	var input = Input.get_axis("brake", "gas_pedal")
	if abs(input) < 0.005:
		return braking_friction()
	var engine_performance:float = clamp(car.linear_velocity.length()/car.top_speed, 0, 1)
	var engine_force:float = input*car.engine_strength*car.engine_curve.sample(engine_performance)
	return forward*engine_force/4

func steer():
	var upward = car.global_basis.y
	var input = Input.get_axis("turn_right", "turn_left")
	if abs(input) < 0.005:
		return stop_spinning_dammit()
	var turn_amount:float = clamp(car.angular_velocity.dot(upward*input)/car.max_spin_rate, -1, 1)
	var turn_torque:float = input*car.turn_strength*car.spin_curve.sample(turn_amount)
	return upward*turn_torque/4

func sliding_friction():
	var rightward:Vector3 = car.global_basis.x
	var lateral_velocity:float = car.linear_velocity.dot(rightward)
	var friction:float = lateral_velocity*car.grip_strength
	return -rightward*friction/4

func braking_friction():
	var forward:Vector3 = -car.global_basis.z
	var forward_velocity:float = car.linear_velocity.dot(forward)
	var braking:float = forward_velocity*car.brake_strength
	return -forward*braking/4

func stop_spinning_dammit():
	var upward:Vector3 = car.global_basis.y
	var spin:float = car.angular_velocity.dot(upward)
	var damp:float = spin*car.damping_factor
	return -damp*upward/4
