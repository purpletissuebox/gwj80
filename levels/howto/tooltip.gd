extends ColorRect

@export_multiline var tip:String
@onready var label:Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.label.text = self.tip

func show_text():
	self.label.show()
	
func hide_text():
	self.label.hide()
