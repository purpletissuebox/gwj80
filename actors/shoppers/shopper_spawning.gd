extends Node3D

@onready var timer: Timer = $Timer
@onready var treeRoot = get_tree().root
@onready var spawnPoints : Array
@export var maxPopulation = 20

var shopperScene = preload("res://actors/shoppers/shopper.tscn")
var currentPopulation = 0

func _process(_delta: float) -> void:
	if currentPopulation >= maxPopulation:
		timer.stop()
	elif currentPopulation < maxPopulation and timer.is_stopped():
		timer.start()

func _get_spawn_points():
	var ary = []
	for child in get_children():
		if child is Marker3D:
			ary += [child]
	return ary
	
func _enter_shopper():
	if spawnPoints.size() < 1:
		spawnPoints = _get_spawn_points()
		return
	var shppr = shopperScene.instantiate()
	shppr.scale = Vector3(4.0,4.0,4.0)
	shppr.position = spawnPoints[randi_range(0,spawnPoints.size()-1)].position
	shppr.representationOfTheSoul = randi_range(0,3)
	treeRoot.add_child(shppr)
	currentPopulation += 1
