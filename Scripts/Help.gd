extends Control

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		close_window()

func _ready():
	get_node("HelpScroll/VBoxContainer/Close").connect("pressed", self, "close_window")

func close_window():
	if visible:
		visible = false
