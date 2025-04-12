extends MeshInstance3D
var t = 0
func _process(delta):
	t = t + delta
	rotate_y(.005)
	self.position.y=sin(1.2 * t) * .5
	
	pass
