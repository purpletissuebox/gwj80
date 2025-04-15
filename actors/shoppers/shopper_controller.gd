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
@export var speed = 10
@export var acceleration = 1
var dir: Vector3
var death_rotation = deg_to_rad(15)
enum States {INIT, MEANDER, LINGER, TRAVERSE, PAUSED}

func _ready() -> void:
	state = States.TRAVERSE

func _physics_process(_delta: float) -> void:
	if state == States.PAUSED:
		body.rotation_degrees.y += 10
		return
	var next_position = navigation_agent_3d.get_next_path_position()
	match state:
		States.TRAVERSE:
			if navigation_agent_3d.is_navigation_finished():
				# HACK.hw - set velocity to zero or else the shopper continues 
				#           flying off the navigation mesh  
				body.velocity = Vector3.ZERO
				_next_state()
		States.MEANDER:
			if navigation_agent_3d.is_navigation_finished():
				_meander()
		States.LINGER:
			_linger()
			
	dir = (next_position - body.global_position).normalized()
	body.velocity = body.velocity.lerp(dir*speed, acceleration)

func _find_destination() -> Vector3:
	var potential_destinations = get_tree().get_nodes_in_group("destinations")
	var index = randi_range(0, potential_destinations.size()-1)
	return potential_destinations[index].position

func _meander():
	if %FaffAroundTimer.is_stopped():
		%FaffAroundTimer.start(randf_range(2.0,6.0))
	navigation_agent_3d.target_position = body.position + Vector3(randf_range(-5.0,5), 0, randf_range(-5.0,5))
	
func _linger():
	if %FaffAroundTimer.is_stopped():
		%FaffAroundTimer.start(randf_range(0.5,3.0))

func _next_state() -> void:
	var roll = randi_range(0, 9)
	
	if roll < 2:
		state = States.LINGER
	elif roll < 8:
		state = States.TRAVERSE
	else:
		state = States.MEANDER 

func get_moving() -> void:	
	state = States.TRAVERSE
	navigation_agent_3d.target_position = _find_destination()

func _so_long() -> void:
	print("Its been good to know ya")
	body.call_deferred("free")
	
func _on_released_from_mortal_coil() -> void:
	%DeathTimer.start(2)
