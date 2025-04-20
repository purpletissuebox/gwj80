extends SubViewport

func _ready():
	SignalBus.ui_show_food.connect(show_food)

func show_food(camera):
	if self.get_child_count() > 0:
		self.remove_child(self.get_child(0))
	var new_cam: Camera3D = camera.duplicate()
	new_cam.top_level = true
	new_cam.position = camera.global_position
	new_cam.rotation = camera.global_rotation
	self.add_child(new_cam)
