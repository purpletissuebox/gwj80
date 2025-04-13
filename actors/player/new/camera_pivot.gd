extends Node3D

@export var car:Cart
@export var follow_speed:float = 20
@export var rotation_speed:float = 5
@export var car_predict:float = 5

@onready var camera_3d: Camera3D = $Camera3D

var car_prediction:Vector3 = Vector3.ZERO

func _ready():
	self.car_prediction = car.global_position

func _physics_process(delta):
	self.global_position = self.global_position.lerp(car.global_position+Vector3(0,3,0), delta*self.follow_speed)
	self.transform = self.transform.interpolate_with(car.transform, delta*rotation_speed)
	self.car_prediction = self.car_prediction.lerp(car.global_position + car.linear_velocity, delta*car_predict)
	camera_3d.look_at(self.car_prediction)
