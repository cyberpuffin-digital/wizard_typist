extends Node

var config_file : ConfigFile
var config_path : String = "user://settings.cfg"
var options_panel : WindowDialog
var screen_position : Vector2
var screen_size : Vector2

func _notification(signal_in):
	if signal_in == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_config()

func _process(delta):
	if OS.get_window_position() != screen_position:
		screen_position = OS.get_window_position()

	if OS.get_window_size() != screen_size:
		screen_size = OS.get_window_size()

func _ready():
	match get_tree().get_current_scene().get_name():
		"Main":
			print("Connecting to save button")
			options_panel = get_node("/root/Main/Options")
			options_panel.find_node("Save").connect("pressed", self, "save_config")
		"Game":
			print("TODO: Set difficulty")
			print("TODO: Connect to game controller")
		_:
			print("Unknown scene: ", get_tree().get_current_scene().get_name())
	load_config()

func load_config():
	var err
	config_file = ConfigFile.new()
	
	while err != OK:
		err = config_file.load(config_path)
		match err:
			OK:
				print("Settings file loaded successfully")
			ERR_FILE_NOT_FOUND:
				print("Unable to find conf file.  Starting fresh.")
				config_file.save(config_path)
			ERR_FILE_CANT_OPEN, ERR_FILE_CANT_READ, ERR_FILE_CANT_WRITE:
				print("Unable to open, read, or write conf file.  Bailing...")
				get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
				break
			_:
				print("Unknown failure when opening conf file.\n%s" % err)
				get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
				break
	parse_config()

func parse_config():
	screen_position.x = config_file.get_value("position", "horizontal", 100)
	screen_position.y = config_file.get_value("position", "vertical", 100)
	screen_size.x = config_file.get_value("display", "width", 1024)
	screen_size.y = config_file.get_value("display", "height", 600)

	OS.set_window_position(screen_position)
	OS.set_window_size(screen_size)

func save_config():
	var err
	print("Saving config to ", config_path)
	
	# Window dimensions and position
	config_file.set_value("position", "horizontal", screen_position.x)
	config_file.set_value("position", "vertical", screen_position.y)
	config_file.set_value("display", "width", screen_size.x)
	config_file.set_value("display", "height", screen_size.y)
	config_file.set_value("gameplay", "difficulty", 100)
	
	# Option panel
	if options_panel:
		var res_button : OptionButton = options_panel.find_node("ResValue", true)
		var res_value : String = res_button.get_item_text(res_button.get_selected_id())
		var res : Vector2 = Vector2(
			int(res_value.split("x", false)[0].strip_edges()),
			int(res_value.split("x", false)[1].strip_edges())
		)
		
		config_file.set_value("display", "width", res.x)
		config_file.set_value("display", "height", res.y)

	err = config_file.save(config_path)
	
	if err != OK:
		print("Failed to save config file.\n%s" % err)
	else:
		parse_config()
