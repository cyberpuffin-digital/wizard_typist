extends KinematicBody2D

signal cast

var verbose : bool = false

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_BACKSPACE:
				var _text = $SpellInput.get_text()
				_text.erase(_text.length() - 1, 1)
				$SpellInput.set_text(_text)
			KEY_ENTER:
				emit_signal("cast", $SpellInput.text)
				$SpellInput.set_text("")
			KEY_ESCAPE:
				if verbose:
					print("UI Cancel event handled by pause menu")
			_:
				$SpellInput.text += sanitize_input(event.get_scancode_with_modifiers())

func _ready():
	$SpellInput.text = ""
	match get_tree().get_current_scene().get_name():
		"Player":
			# Player testing
			position = Vector2(100, 100)
			$Avatar.play()
			$Wand.play()
		"Game":
			# Main game
			$Avatar.play()
		_:
			hide()

func sanitize_input(user_input : int) -> String:
	var output_string : String = OS.get_scancode_string(user_input)
	var upper_case : bool = false

	if verbose:
		print("Input code \"%d\": %s" % [user_input, output_string])

	# Handle special characters
	if "+" in output_string:
		output_string = output_string.replace("+", "")
	if "Comma" in output_string:
		output_string = ","
	if "Period" in output_string:
		output_string = "."
	if "Shift" in output_string:
		upper_case = true
		output_string = output_string.replace("Shift", "")
	if "Space" in output_string:
		output_string = " "
	if "Tab" in output_string:
		output_string = " "

	if !upper_case:
		output_string = output_string.to_lower()

	if verbose:
		print("Output string: ", output_string)

	if output_string.length() > 1:
		return ""
	else:
		return output_string
