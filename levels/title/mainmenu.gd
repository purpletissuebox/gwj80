extends Control

func start_game():
	get_tree().change_scene_to_file("res://levels/Store/Store.tscn")

func do_options():
	pass

func quit_game():
	get_tree().quit()
