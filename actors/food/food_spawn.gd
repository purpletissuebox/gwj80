class_name Shelf extends Node3D
	
var t = 0
var shown_food:Node3D = null
var shown_food_type:int = -1

var spawns:Array[Marker3D] = []
var chosen_spawn:Marker3D = null

# Uncomment for Spawn Testing
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
	
	for node in self.get_children():
		if node is Marker3D:
			spawns.append(node)
			for child in node.get_children():
				if child is Area3D:
					child.connect("body_entered", pickup_food)
	
	# Uncomment for Spawn Testing
	#SignalBus.spawn_food.emit(self, foods[3], 3)
	#await get_tree().create_timer(2.0).timeout
	
func register_shelf(i):
	if i is not Object:
		SignalBus.register_shelf.emit(self)
	
func show_food(shelf, food, food_type):
	if shelf == self:
		shown_food = food.instantiate()
		shown_food_type = food_type
		chosen_spawn = spawns.pick_random()
		chosen_spawn.add_child(shown_food)
		chosen_spawn.find_child("SpotLight3D").visible = true
		SignalBus.arrow_point.emit(chosen_spawn)
		SignalBus.ui_show_food.emit(chosen_spawn.get_child(0))
		
func pickup_food(body: Node3D):
	if shown_food and body is ShoppingCart:
		shown_food.queue_free()
		SignalBus.remove_food.emit(shown_food_type)
		shown_food_type = -1
		chosen_spawn.find_child("SpotLight3D").visible = false
		chosen_spawn = null
	
func _process(delta:float):
	if shown_food:
		t += delta
		shown_food.rotate_y(.005)
		shown_food.position.y = sin(1.2 * t) * .5
