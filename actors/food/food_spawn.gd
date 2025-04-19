extends Marker3D
	
var foods = [
	preload("res://models/BEANS.glb"),
	preload("res://models/bapple.glb"),
	preload("res://models/bread.glb"),
	preload("res://models/broccoli.glb"),
	preload("res://models/mushyfriend.glb"),
]
var t = 0
var has_child = false

func _ready():
	SignalBus.spawn_food.connect(show_food)
	
	SignalBus.spawn_food.emit(0)
	
func show_food(food_type):
	var food = foods[food_type].instantiate()
	add_child(food)
	has_child = true
	
func _process(delta:float):
	if has_child:
		var food = get_child(-1)
		t += delta
		food.rotate_y(.005)
		food.position.y = sin(1.2 * t) * .5

#func _on_food_attempt_capture(area: Area3D) -> void:
	#if has_child:
		#
