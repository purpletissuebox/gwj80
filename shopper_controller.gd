class_name ShopperController extends Node

# TODO.hw - implement navigation pathing for shopper mobs
# will want a couple types: Grannies, Kiddos, Shelfstockers
# Grannies - meander to item spawn points, blocking the isle, stop and peruse items
# Shelfstockers - move at a moderate pace to item spawn points, takes direct paths, lingers to restock
# Kiddos - spawn of Satan, will run around with no concern for themselves or others

# TODO.hw - add a Manager control scheme that wanders the store and if seeing the player hunts
# them down to kick them out.

# TODO.hw setup states - meander, linger, traverse
# meander - randome wander around the radius of the current position
# linger - remain still
# traverse - head directly to next point
@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"
@export var body: CharacterBody3D
var v_o = 1
var a = 1
var dir: Vector3
var state
enum {MEANDER, LINGER, TRAVERSE}
func _physics_process(delta: float) -> void:
	navigation_agent_3d.target_position = _find_destination()
	dir = (navigation_agent_3d.get_next_path_position() - body.global_position).normalized()
	body.velocity = body.velocity.lerp(dir*v_o, 1)

func _find_destination() -> Vector3:
	var closest_location = Vector3(10000,10000,10000)
	var potential_destinations = get_tree().get_nodes_in_group("destinations")
	for destination in potential_destinations:
		if _3d_distance_to_2d(body.position, destination.position) < _3d_distance_to_2d(body.position, closest_location):
			closest_location = destination.position
			
	return closest_location
	
# TODO.hw - upon collision emit death
func _3d_distance_to_2d(pos1,pos2):
	return Vector2(pos1.x,pos1.z).distance_to(Vector2(pos2.x,pos2.z))

func _find_next_point():
	match state:
		MEANDER:
			pass
		LINGER:
			pass
		TRAVERSE:
			pass
