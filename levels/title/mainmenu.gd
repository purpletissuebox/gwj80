extends Control

@onready var vol_slider = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VSlider
@onready var credits_screen = $Credits
func _ready():
	vol_slider.value = AudioDriver.global_bgm_volume

func start_game():
	get_tree().change_scene_to_file("res://levels/Store/Store.tscn")

func open_credits():
	credits_screen.visible = true

func close_credits():
	credits_screen.visible = false

func quit_game():
	get_tree().quit()

func _on_vol_changed(value: float) -> void:
	AudioDriver.global_bgm_volume = value
	AudioDriver.global_sfx_volume = value
