extends Camera3D

@export var car:ShoppingCart
@export var arm:SpringArm3D
@export var move_tgt:Marker3D
@export var look_tgt:Marker3D

var prev_speed:float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	zoom(delta)
	self.global_position = lerp(self.global_position, move_tgt.global_position - car.global_basis.x.cross(car.angular_velocity), 20*delta)
	var old_rot = self.rotation.z
	look_at(look_tgt.global_position)
	self.rotation.z = lerp(old_rot, -car.rotation.x, 5*delta)

func zoom(delta):
	var cur_speed = car.linear_velocity.dot(car.global_basis.x)
	var acceleration = cur_speed - prev_speed
	var desired_length:float = 9.0 + 0.5*acceleration
	arm.spring_length = lerp(arm.spring_length, desired_length, delta)
	self.prev_speed = cur_speed
