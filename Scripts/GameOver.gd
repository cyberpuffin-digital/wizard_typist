extends Popup

var parent_obj : Control

func _ready():
	parent_obj = get_parent()

	get_node("ScrollContainer/VBoxContainer/Controls/Restart").connect("pressed", parent_obj, "restart_game")
	get_node("ScrollContainer/VBoxContainer/Controls/Main_menu").connect("pressed", parent_obj, "return_to_menu")
	get_node("ScrollContainer/VBoxContainer/Controls/Exit").connect("pressed", parent_obj, "exit_game")
