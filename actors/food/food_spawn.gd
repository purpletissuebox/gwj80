extends Node

var foodDisplayScene = preload("res://actors/food/DisplayFood.tscn")
	
func _ready():
	for spawn in get_children():
		if spawn is Marker3D:
			var food = foodDisplayScene.instantiate()
			spawn.add_child(food)
	#food.position = spawnPoints[randi_range(0,spawnPoints.size()-1)].position
