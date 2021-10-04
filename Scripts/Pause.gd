extends WindowDialog

var pause_timer : float

func _ready():
	pause_timer = 0
	connect("popup_hide", self, "unpause")
	get_node("VBoxContainer/Main Menu").connect("pressed", self, "return_to_menu")
	get_node("VBoxContainer/Resume Game").connect("pressed", self, "resume_game")
	get_node("VBoxContainer/Quit Game").connect("pressed", self, "exit_game")

func _process(delta):
	pause_timer -= delta
	if Input.is_action_pressed("ui_cancel") and pause_timer <= 0:
		print("Pause timer: %f" % pause_timer)
		reset_timer()
		if visible:
			unpause()
			hide()
		else:
			get_tree().paused = true
			popup_centered_ratio(0.5)

func exit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func reset_timer():
	if pause_timer <= 0:
		pause_timer = 2.0

func return_to_menu():
	get_tree().change_scene("res://Scenes/Menus/Main_menu.tscn")
	
func resume_game():
	hide()
	
func unpause():
	get_tree().paused = false
