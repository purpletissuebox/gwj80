extends Node

var shelves = []
var foods = [
	preload("res://models/BEANS.glb"),
	preload("res://models/bapple.glb"),
	preload("res://models/bread.glb"),
	preload("res://models/broccoli.glb"),
	preload("res://models/mushyfriend.glb"),
]

func _ready():
	SignalBus.register_shelf.connect(register_shelf)
	SignalBus.remove_food.connect(_on_food_removed)
	SignalBus.register_shelf.emit(-1)
	
	select_food_spawn()

func register_shelf(shelf):
	if shelf is Object:
		shelves.append(shelf)

func select_food_spawn():
	var target = shelves.pick_random()
	print(target)
	var chosen_food = range(5).pick_random()
	print(chosen_food)
	SignalBus.spawn_food.emit(target, foods[chosen_food], chosen_food)

func _on_food_removed(removed_food):
	print("You removed a foods")
	select_food_spawn()
