extends Window

signal higher
signal lower
signal reset

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_close_requested():
	self.queue_free()


func _on_button_reset_button_down():
	emit_signal("reset")

func _on_button_down_button_down():
	emit_signal("lower")

func _on_button_up_button_down():
	emit_signal("higher")