class_name Shopper extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var navigation_controller: ShopperController = $NavigationController

@export var monetaryValueOfLife : int
@export var representationOfTheSoul : CompressedTexture2D

signal releasedFromMortalCoil

var collision_force = 1

func _ready() -> void:
	sprite_3d.texture = load("res://actors/shoppers/eldenRingHarrison.png")
	sprite_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("body: ", body)
	#print(body.rotation_degrees)
	#print(get_slide_collision_count())
	# TODO.hw - apply force in direction of colliding object
	if body is ShoppingCart:
		navigation_controller.state = navigation_controller.States.PAUSED
		var collision_velocity = body.linear_velocity
		#collision_force.y = 0
		sprite_3d.billboard = BaseMaterial3D.BILLBOARD_DISABLED
		releasedFromMortalCoil.emit()
		velocity += collision_velocity*collision_force
