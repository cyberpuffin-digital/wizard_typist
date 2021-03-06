extends Control

signal save

var settings_file : String = "user://settings.save"

func _ready():
	get_tree().paused = false
	get_node("Buttons/Start").connect("pressed", self, "start_game")
	get_node("Buttons/Options").connect("pressed", self, "display_options")
	get_node("Buttons/Exit").connect("pressed", self, "exit_game")
	get_node("Options/Save").connect("pressed", self, "save_options")
	get_node("HelpButton").connect("pressed", self, "help_button")

func display_options():
	get_node("Options").popup_centered_ratio(0.5)

func exit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func help_button():
	$Help.visible = !$Help.visible

func save_options():
	emit_signal("save")

func start_game():
	get_tree().change_scene("res://Scenes/Levels/Game.tscn")
