extends Area3D

func _on_shelf_pickup_area_entered(area: Area3D) -> void:
	AudioDriver.play_sfx("res://levels/Store/Sound/You_Know.mp3")
