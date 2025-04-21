extends Node

var shelves = []
var foods = [
	preload("res://models/BEANS.glb"),
	preload("res://models/bapple.glb"),
	preload("res://models/bread.glb"),
	preload("res://models/broccoli.glb"),
	preload("res://models/mushyfriend.glb"),
]
var grocery_prices = {
	SignalBus.foods.beans:20,
 	SignalBus.foods.apple:55,
	SignalBus.foods.bread:101,
	SignalBus.foods.broccoli:34,
	SignalBus.foods.mushroom:17,
}

var grocery_list = []
var groceries_acquired = []
var grocery_total : int

func _ready():
	for child in self.get_tree().root.get_children():
		if child is Shopper:
			child.queue_free()
			
	SignalBus.register_shelf.connect(register_shelf)
	SignalBus.remove_food.connect(_on_food_removed)
	SignalBus.checkout.connect(on_checkout)
	SignalBus.request_grocery_list.connect(send_groceries)
	SignalBus.register_shelf.emit(-1)
	SignalBus.current_day += 1
	grocery_total = SignalBus.current_day*4
	_generate_grocery_list()
	select_food_spawn()

func register_shelf(shelf):
	if shelf is Object:
		shelves.append(shelf)

func select_food_spawn():
	var target = shelves.pick_random()
	var chosen_food = grocery_list.pick_random()
	if chosen_food != null:
		SignalBus.spawn_food.emit(target, foods[chosen_food], chosen_food)

func _on_food_removed(removed_food):
	if removed_food in SignalBus.foods:
		groceries_acquired += [removed_food]
	grocery_list.remove_at(grocery_list.find(removed_food))
	SignalBus.ui_update_grocery_list.emit(grocery_list)
	select_food_spawn()

func _generate_grocery_list():
	for i in grocery_total:
		grocery_list += [randi_range(SignalBus.foods.beans,SignalBus.foods.mushroom)]
	SignalBus.ui_update_grocery_list.emit(grocery_list)

func on_checkout():
	if grocery_list.is_empty() and _check_money():
		SignalBus.winner.emit()
		
func _check_money():
	print("to enter new vegas you must submit to a credit check")
	var total_needed = 0
	var wallet = get_tree().root.find_child("Wallet", true, false)
	for grocery in groceries_acquired:
		total_needed += grocery_prices[grocery]
	if total_needed <= wallet.total_money:
		wallet.total_money -= total_needed
		SignalBus.total_points += wallet.total_money + total_needed
		SignalBus.current_money = wallet.total_money
		SignalBus.change_money.emit(0)
		AudioDriver.play_sfx("res://sounds/sound_effects/kaching.ogg")
		return true
	else:
		AudioDriver.play_sfx("res://sounds/pa/Clean/mf_pay_for_that.mp3")
		return false

func send_groceries():
	SignalBus.ui_update_grocery_list.emit(grocery_list)
