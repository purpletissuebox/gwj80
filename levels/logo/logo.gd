extends Control

@onready var timer: Timer = $Timer

func _ready():
	await timer.timeout
	SignalBus.change_lvl.emit("res://levels/title/mainmenu.tscn", 1.0)
