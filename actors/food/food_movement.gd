extends Node3D

var t = 0
func _process(delta):
	t += delta
	rotate_y(.005)
	self.position.y = sin(1.2 * t) * .5
