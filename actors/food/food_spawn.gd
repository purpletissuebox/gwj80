class_name Shelf extends Node3D
	
var t = 0
var shown_food = null
#var has_food = false
var shown_food_type = -1

#var foods = [
	#preload("res://models/BEANS.glb"),
	#preload("res://models/bapple.glb"),
	#preload("res://models/bread.glb"),
	#preload("res://models/broccoli.glb"),
	#preload("res://models/mushyfriend.glb"),
#]

func _ready():
	SignalBus.register_shelf.connect(register_shelf)
	SignalBus.spawn_food.connect(show_food)
	
	#SignalBus.spawn_food.emit(self, foods[0], 0)
	#await get_tree().create_timer(2.0).timeout
	#pickup_food($FoodSpawn/Area3D)
	#await get_tree().create_timer(2.0).timeout
	#SignalBus.spawn_food.emit(self, foods[3], 3)
	
func register_shelf(i):
	if i is not Object:
		SignalBus.register_shelf.emit(self)
	
func show_food(shelf, food, food_type):
	if shelf == self:
		shown_food = food.instantiate()
		shown_food_type = food_type
		$FoodSpawn.add_child(shown_food)
		SignalBus.ui_show_food.emit($FoodSpawn/Camera3D)
		
func pickup_food(area: Area3D):
	if shown_food and area.get_parent() is ShoppingCart:
		shown_food.queue_free()
		SignalBus.remove_food.emit(shown_food_type)
		shown_food_type = -1
	
func _process(delta:float):
	if shown_food:
		t += delta
		shown_food.rotate_y(.005)
		shown_food.position.y = sin(1.2 * t) * .5
