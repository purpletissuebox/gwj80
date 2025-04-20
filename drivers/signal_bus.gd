extends Node

signal change_lvl
signal change_money(int)

enum foods {
	beans,
	apple,
	bread,
	broccoli,
	mushroom,
}
signal register_shelf(shelf)
signal spawn_food(shelf, food)
signal remove_food(foods)

signal ui_show_food(camera)
