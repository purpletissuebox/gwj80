extends Node3D

var target:Vector3 = Vector3.ZERO
var player:Camera3D

func _ready():
	SignalBus.spawn_food.connect(self.update_tgt)
	SignalBus.register_player_cam.connect(self.get_camera)

func _process(_delta):
	if player:
		swivel()

func swivel():
	var camera_pos:Vector3 = player.global_position
	var loc:Vector3 = target - camera_pos + self.global_position
	var camera_norm:Vector3 = -player.global_basis.z
	var camera_basis:Basis = Basis.looking_at(camera_norm)
	var dst = loc*camera_basis
	self.look_at(dst)

func update_tgt(shelf, _food):
	self.target = shelf.global_position

func get_camera(c):
	self.player = c
