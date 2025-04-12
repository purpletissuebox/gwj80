class_name ShoppingCart extends RigidBody3D

@export var steer_force:Curve
@export var engine_force:Curve
const TOP_SPEED:float = 300
const STEER_RATE:float = PI/4
const CAR_MASS:float = 100
const FRONT_TIRES:int = 0
const BACK_TIRES:int = 2
const NUM_TIRES:int = 4

var wheel_angle:float = 0
var wheels:Array[Vector3]

#func _ready():
	#var marker_3d: Marker3D = $Marker3D
	#for i in NUM_TIRES:
		#var v:Vector3 = marker_3d.position
		#v.z *= (1 if i&1 else -1)
		#v.x *= (1 if i&2 else -1)
		#self.wheels.append(v)
	#marker_3d.queue_free()

func get_wheel_speed(w:Wheel):
	return self.linear_velocity + self.angular_velocity.cross(w.position)
	
