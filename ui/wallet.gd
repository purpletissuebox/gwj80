extends Control

@export var bill_scale = Vector2(0.25, 0.25)
var total_money = SignalBus.current_money
var denominations = [10000, 5000, 1000, 500, 100, 50, 20, 10, 5, 2, 1]
var tender = {
	10000:preload("res://sprites/money/10000USD.jpg"), 5000:preload("res://sprites/money/5000USD.jpg"),
	1000:preload("res://sprites/money/1000USD.jpg"),   500:preload("res://sprites/money/500USD.jpg"),
	100:preload("res://sprites/money/100USD.jpg"),     50:preload("res://sprites/money/50USD.jpg"), 
	20:preload("res://sprites/money/20USD.jpg"),       10:preload("res://sprites/money/10USD.jpg"), 
	5:preload("res://sprites/money/Fiver.jpg"),
	2:preload("res://sprites/money/2USD.jpg"), 1:preload("res://sprites/money/1USD.jpg")}

func _ready() -> void:
	SignalBus.change_money.connect(display_money)
	display_money(0)
	
func display_money(amount:int):
	total_money += amount
	var remainder = total_money
	var total_bills = 0
	for denomination in denominations:
		var row = find_child(str(denomination)+"$Row")
		var cur_bills = row.get_child_count()
		total_bills = remainder / denomination
		remainder = remainder % denomination
		
		if cur_bills == total_bills:
			continue
		elif cur_bills < total_bills:
			for bill in total_bills:
				var text_rect = TextureRect.new()
				text_rect.texture = tender[denomination]
				row.add_child(text_rect)
		else:
			for i in range(cur_bills-total_bills+1):
				row.get_child(0).queue_free()
