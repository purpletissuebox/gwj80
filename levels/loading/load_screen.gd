extends Control

@onready var cache: CanvasLayer = $CanvasLayer
@onready var label_2: Label = $ColorRect/VBoxContainer/Label2

func _ready():
	await cache.all_done
	label_2.show()
	SignalBus.change_lvl.emit("res://levels/logo/logo.tscn", 1.0)
