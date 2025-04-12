extends MeshInstance3D

func _process(delta):
	var target_plane = Plane(Vector3(0,1,0), position.y)
	var ray_len = 1000
	var mp = get_viewport().get_mouse_position()
	var from = $"../Camera3D".project_ray_origin(mp)
	var to = from + $"../Camera3D".project_ray_normal(mp) * ray_len
	var cursor_pos = target_plane.intersects_ray(from, to)
	$".".look_at(cursor_pos, Vector3.MODEL_FRONT, 0)
	pass
