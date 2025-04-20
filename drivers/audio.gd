extends Node

var global_bgm_volume:float = 1.0
var global_sfx_volume:float = 1.0
var bgm_player:AudioStreamPlayer
var sfx_players:Array[AudioStreamPlayer]

func _ready():
	self.bgm_player = AudioStreamPlayer.new()
	self.add_child(bgm_player)

func play_bgm(filepath:String, fade_time:float = 0.5, volume:float = 1.0):
	play_audio(filepath, self.bgm_player, volume*global_bgm_volume, fade_time)

func play_sfx(filepath:String, volume:float = 1.0):
	var player:AudioStreamPlayer = AudioStreamPlayer.new()
	player.finished.connect(self.stop_audio.bind(player, 0, true))
	
	self.add_child(player)
	return play_audio(filepath, player, volume*global_sfx_volume, 0)

func play_audio(filepath:String, player:AudioStreamPlayer, volume:float, fade_len:float):
	var t = create_tween()
	t.set_trans(Tween.TRANS_EXPO)
	t.set_ease(Tween.EASE_IN)
	t.finished.connect(t.kill)
	
	player.volume_db = -80
	player.stream = load(filepath)
	player.play()
	t.tween_property(player, "volume_db", linear_to_db(volume), fade_len)
	return player

func stop_audio(p:AudioStreamPlayer, duration:float, kill:bool = false):
	var t = create_tween()
	t.set_trans(Tween.TRANS_EXPO)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(p, "volume_db", -60, duration)
	await t.finished
	t.kill()
	
	p.stop()
	if kill:
		p.get_parent().remove_child(p)
		p.queue_free()
