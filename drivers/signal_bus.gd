extends Node

signal change_lvl
signal change_money(int)

enum food_types {beans, apple, bread, broccoli, mushroom}
signal spawn_food(food_types)
signal captured_food(food_types)
