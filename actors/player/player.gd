extends VehicleBody3D

@onready var vehicle_wheel_3d: VehicleWheel3D = $VehicleWheel3D

func _ready():
	for i in range(1,4):
		var new_wheel:VehicleWheel3D = vehicle_wheel_3d.duplicate()
		new_wheel.position.x *= (-1 if i & 1 else 1)
		new_wheel.position.z *= (-1 if i & 2 else 1)
		self.add_child(new_wheel)

func _physics_process(delta):
	self.engine_force = int(Input.is_action_pressed("gas_pedal"))*100
	self.steering = Input.get_axis("turn_left", "turn_right")
