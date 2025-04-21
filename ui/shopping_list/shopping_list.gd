extends Control

var food_viewports = {
	SignalBus.foods.beans:preload("res://ui/shopping_list/beans_sub_viewport_container.tscn"),
	SignalBus.foods.apple:preload("res://ui/shopping_list/bapple_sub_viewport_container.tscn"),
	SignalBus.foods.bread:preload("res://ui/shopping_list/bread_sub_viewport_container.tscn"),
	SignalBus.foods.broccoli:preload("res://ui/shopping_list/broccoli_sub_viewport_container.tscn"),
	SignalBus.foods.mushroom:preload("res://ui/shopping_list/mushroom_sub_viewport_container.tscn"),
}
func _ready() -> void:
	SignalBus.ui_update_grocery_list.connect(on_grocery_list_update)
	SignalBus.request_grocery_list.emit()
	
func on_grocery_list_update(list):
	for child in get_children():
		child.queue_free()
		
	for item in list:
		var food_view:SubViewportContainer = food_viewports[item].instantiate()
		food_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		food_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
		food_view.stretch = true
		add_child(food_view)
