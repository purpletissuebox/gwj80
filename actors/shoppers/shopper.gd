class_name Shopper extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var navigation_controller: ShopperController = $NavigationController
@onready var money_emitter: GPUParticles3D = $MoneyEmitter

@export_category("Shopper Properties")
@export var monetaryValueOfLife : int = 0
@export_enum("Brewboy", "Bussnessman", "Granny", "Karen") var representationOfTheSoul

const avatars := [preload("res://sprites/brewboy.png"), preload("res://sprites/bussnessman.png"),
				  preload("res://sprites/grannynanny.png"), preload("res://sprites/Karen.png")]

signal releasedFromMortalCoil

var collision_force = 1

func _ready() -> void:
	match representationOfTheSoul:
		"Brewboy":
			sprite_3d.texture = avatars[0]
			monetaryValueOfLife =  randi_range(10,50)
		"Bussnessman":
			sprite_3d.texture = avatars[1]
			monetaryValueOfLife =  randi_range(100,300)
		"Granny":
			sprite_3d.texture = avatars[2]
			monetaryValueOfLife =  randi_range(40,100)
		"Karen":
			sprite_3d.texture = avatars[3]
			monetaryValueOfLife =  randi_range(60,120)
		_:
			sprite_3d.texture = load("res://actors/shoppers/eldenRingHarrison.png")
			monetaryValueOfLife = 0
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
		money_emitter.emitting = true
		sprite_3d.billboard = BaseMaterial3D.BILLBOARD_DISABLED
		releasedFromMortalCoil.emit()
		SignalBus.change_money.emit(monetaryValueOfLife)
		velocity += collision_velocity*collision_force
