extends Node3D

#play clips in order
var index = 0

var pay_sounds = [
	"res://sounds/pa/Clean/mf_pay_for_that.mp3",
	"res://sounds/pa/Clean/pay.mp3"
]

func _ready() -> void:
	var node = self
	for child in node.get_children():
		if child is Area3D:
			child.connect("body_entered", pay_for_that)
	pass

func pay_for_that(body: Node3D):
	if body is ShoppingCart:
		AudioDriver.play_sfx(pay_sounds[index], 2.0)
		index += 1
		if index == pay_sounds.size():
			index = 0
	pass
