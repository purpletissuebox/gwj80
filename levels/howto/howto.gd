extends Control


func go_home():
	SignalBus.change_lvl.emit("res://levels/title/mainmenu.tscn", 0)
