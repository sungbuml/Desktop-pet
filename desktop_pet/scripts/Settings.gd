extends Window

signal higher
signal lower
signal reset
signal change_pet(id)

var cur_state: int = 1

func _ready():
	get_node("VBoxContainer/OptionButton").select(cur_state)

func _on_close_requested():
	self.queue_free()


func _on_button_reset_button_down():
	emit_signal("reset")

func _on_button_down_button_down():
	emit_signal("lower")

func _on_button_up_button_down():
	emit_signal("higher")

func _on_option_button_item_selected(index:int):
	emit_signal("change_pet", index)