class_name ShelfPickup
extends Area3D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", _cart_touch)

func _cart_touch(hitbox: CartBodyHitbox) -> void:
	if hitbox == null:
		return
	else:
		AudioDriver.play_sfx("res://levels/Store/Sound/You_Know.mp3")
