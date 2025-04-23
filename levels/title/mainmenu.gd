extends Control

@onready var vol_slider = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VSlider
@onready var credits_screen = $Credits

var sound_cooldown:float = 0

func _process(delta: float) -> void:
	if sound_cooldown >= 0:
		sound_cooldown -= delta

func _ready():
	vol_slider.value = AudioDriver.global_bgm_volume

func start_game():
	AudioDriver.play_bgm("res://levels/Store/bgm.mp3", 0.15, 0.75)
	get_tree().change_scene_to_file("res://levels/Store/NewStore.tscn")

func open_credits():
	credits_screen.visible = true

func close_credits():
	credits_screen.visible = false

func quit_game():
	get_tree().quit()
	
func show_help():
	SignalBus.change_lvl.emit("res://levels/howto/howto.tscn", 0)

func _on_vol_changed(value: float) -> void:
	AudioDriver.global_bgm_volume = value
	AudioDriver.global_sfx_volume = value
	if sound_cooldown <= 0:
		sound_cooldown += 0.5
		AudioDriver.play_sfx("res://levels/title/volume.mp3", 0.7)
