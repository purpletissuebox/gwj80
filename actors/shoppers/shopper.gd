class_name Shopper extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D

@export var monetaryValueOfLife : int
@export var representationOfTheSoul : CompressedTexture2D

signal releasedFromMortalCoil

func _ready() -> void:
	sprite_3d.texture = load("res://actors/shoppers/eldenRingHarrison.png")
	sprite_3d.billboard = 1
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_collision(area: Area3D) -> void:
	releasedFromMortalCoil.emit()
	for collision_index in get_slide_collision_count()-1:
		var collision = get_slide_collision(collision_index)
		if collision == area:
			print(area)
			var normal = collision.get_normal()
			# TODO.hw - apply force in direction of colliding object
	pass # Replace with function body.
