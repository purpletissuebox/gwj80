extends Node

var secs_left = 60

func _process(delta: float) -> void:
	secs_left -= delta
	self.value = (secs_left / 60) * 100
