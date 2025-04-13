class_name ShopperController extends Node

# TODO.hw - implement navigation pathing for shopper mobs
# will want a couple types: Grannies, Kiddos, Shelfstockers
# Grannies - meander to item spawn points, blocking the isle, stop and peruse items
# Shelfstockers - move at a moderate pace to item spawn points, takes direct paths, lingers to restock
# Kiddos - spawn of Satan, will run around with no concern for themselves or others

# TODO.hw - add a Manager control scheme that wanders the store and if seeing the player hunts
# them down to kick them out.

@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"
@export var body: CharacterBody3D
@export var state: States
var speed = 10
var a = 1
var dir: Vector3

enum States { MEANDER, LINGER, TRAVERSE}

func _ready() -> void:
	state = States.TRAVERSE

func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	match state:
		States.TRAVERSE:
			dir = (next_position - body.global_position).normalized()
			body.velocity = body.velocity.lerp(dir*speed, 1)
			
			if navigation_agent_3d.is_navigation_finished():
				# HACK.hw - set velocity to zero or else the shopper continues 
				#           flying off the navigation mesh  
				body.velocity = Vector3.ZERO
				_next_state()
		States.MEANDER:
			_meander()
		States.LINGER:
			_linger()


func _find_destination() -> Vector3:
	var potential_destinations = get_tree().get_nodes_in_group("destinations")
	var index = randi_range(0, potential_destinations.size()-1)
	return potential_destinations[index].position

func _meander():
	# TODO.hw - wander around in a radius around the shopper
	get_moving()
	
func _linger():
	if %FaffAroundTimer.is_stopped():
		%FaffAroundTimer.start()

func _next_state() -> void:
	var roll = randi_range(0, 9)
	
	if roll < 2:
		state = States.LINGER
	elif roll < 7:
		state = States.TRAVERSE
	else:
		state = States.MEANDER 

func get_moving() -> void:
	state = States.TRAVERSE
	navigation_agent_3d.target_position = _find_destination()
