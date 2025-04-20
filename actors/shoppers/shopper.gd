class_name Shopper extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var navigation_controller: ShopperController = $NavigationController
@onready var money_emitter: GPUParticles3D = $MoneyEmitter

@export_category("Shopper Properties")
@export var monetaryValueOfLife : int = 0
enum ShopperPhenotype {BREWBOY,BUSSNESSMAN,GRANNY,KAREN}
@export_enum("Brewboy", "Bussnessman", "Granny", "Karen") var representationOfTheSoul : int

const avatars := [preload("res://sprites/brewboy.png"), preload("res://sprites/bussnessman.png"),
				  preload("res://sprites/grannynanny.png"), preload("res://sprites/Karen.png")]

var sounds = [
"res://sounds/hit_sounds/ahh.mp3",
"res://sounds/hit_sounds/grandma_rude.mp3",
"res://sounds/hit_sounds/lawyer.mp3",
"res://sounds/hit_sounds/mid_ow.mp3",
"res://sounds/hit_sounds/myleg.mp3",
"res://sounds/hit_sounds/oof.mp3",
"res://sounds/hit_sounds/ouch.mp3",
"res://sounds/hit_sounds/ow.mp3",
"res://sounds/hit_sounds/uncivie.mp3",
"res://sounds/hit_sounds/waaah.mp3"
]

signal releasedFromMortalCoil

var collision_force = 5

func _ready() -> void:
	match representationOfTheSoul:
		ShopperPhenotype.BREWBOY:
			sprite_3d.texture = avatars[0]
			monetaryValueOfLife =  randi_range(10,50)
		ShopperPhenotype.BUSSNESSMAN:
			sprite_3d.texture = avatars[1]
			monetaryValueOfLife =  randi_range(100,300)
		ShopperPhenotype.GRANNY:
			sprite_3d.texture = avatars[2]
			monetaryValueOfLife =  randi_range(40,100)
		ShopperPhenotype.KAREN:
			sprite_3d.texture = avatars[3]
			monetaryValueOfLife =  randi_range(60,120)
		_:
			sprite_3d.texture = load("res://actors/shoppers/eldenRingHarrison.png")
			monetaryValueOfLife = 0
	sprite_3d.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:

	if body is ShoppingCart:
		navigation_controller.state = navigation_controller.States.PAUSED
		var collision_velocity = body.linear_velocity

		money_emitter.emitting = true
		sprite_3d.billboard = BaseMaterial3D.BILLBOARD_DISABLED
		AudioDriver.play_sfx("res://sounds/sound_effects/kaching.ogg", 2.0)
		AudioDriver.play_sfx(sounds[randi_range(0,9)], 2.0)
		releasedFromMortalCoil.emit()
		SignalBus.change_money.emit(monetaryValueOfLife)
		
		velocity += collision_velocity*collision_force
