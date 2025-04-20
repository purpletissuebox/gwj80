extends MeshInstance3D

var t = 0

func _process(delta:float):
	t += delta
	rotate_y(.05)
	self.position.y=sin(1.2 * t) * .5
