extends Control

var grid_container: GridContainer

var food_viewports = {
	SignalBus.foods.beans:preload("res://ui/shopping_list/beans_sub_viewport_container.tscn"),
	SignalBus.foods.apple:preload("res://ui/shopping_list/bapple_sub_viewport_container.tscn"),
	SignalBus.foods.bread:preload("res://ui/shopping_list/bread_sub_viewport_container.tscn"),
	SignalBus.foods.broccoli:preload("res://ui/shopping_list/broccoli_sub_viewport_container.tscn"),
	SignalBus.foods.mushroom:preload("res://ui/shopping_list/mushroom_sub_viewport_container.tscn"),
}
func _ready() -> void:
	grid_container = GridContainer.new()
	grid_container.columns = 2
	get_child(0).add_child(grid_container)
	SignalBus.ui_update_grocery_list.connect(on_grocery_list_update)
	SignalBus.request_grocery_list.emit()
	
func on_grocery_list_update(list):
	for item in list:
		var vp = food_viewports[item].instantiate()
		grid_container.add_child(vp)
