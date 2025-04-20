extends Node3D

var target:Vector3 = Vector3.ZERO
var player:Camera3D

func _ready():
	SignalBus.spawn_food.connect(self.update_tgt)
	SignalBus.register_player_cam.connect(self.get_camera)

func _process(_delta):
	if player:
		swivel(self.target)

func swivel(tgt:Vector3):
	var local_tgt:Vector3 = tgt - player.global_position + self.global_position
	var camera_look_dir:Vector3 = -player.global_basis.z
	var camera_coordinate_system:Basis = Basis.looking_at(camera_look_dir)
	var dst = local_tgt*camera_coordinate_system
	self.look_at(dst)

func update_tgt(shelf, _food):
	self.target = shelf.global_position

func get_camera(c):
	self.player = c
