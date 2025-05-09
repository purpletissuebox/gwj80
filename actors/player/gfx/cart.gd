extends Node3D

@export var car:ShoppingCart

func _physics_process(_delta):
	self.rotation.x = 0
	self.rotation.y = -PI/2
	
	var angvel = car.angular_velocity.dot(car.global_basis.y)
	self.rotation.z = angvel*0.1
	
	self.rotation += 0.03*jitter()

func jitter():
	var sratio = car.linear_velocity.dot(car.global_basis.x)
	sratio /= car.top_speed
	return sratio*Vector3(randf(), randf(), randf())
