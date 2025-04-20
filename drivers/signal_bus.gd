extends Node

signal change_lvl
signal change_money(int)
signal checkout

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
signal ui_update_grocery_list(list)
signal request_grocery_list
signal game_over
signal winner
