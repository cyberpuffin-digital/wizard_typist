extends Node

static func process_input(event) -> String:
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_BACKSPACE:
				print("Backspace")
			KEY_ENTER:
				print("Enter")
			KEY_ESCAPE:
				print("Escape")
			_:
				return sanitize_input(event.get_scancode_with_modifiers())
	return ""

static func sanitize_input(user_input : int) -> String:
	var output_string : String = OS.get_scancode_string(user_input)
	var upper_case : bool = false

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

	print("Output string: ", output_string)

	if output_string.length() > 1:
		return ""
	else:
		return output_string
