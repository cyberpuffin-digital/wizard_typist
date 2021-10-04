extends Control

var matched_text : String
var pending_text : String

const INPUT = preload("res://Scripts/Library/input.gd")

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			_:
				test_input(INPUT.process_input(event))

func _ready():
	pending_text = $Text/paragraph.text

func test_input(text_in : String):
	print("testing %s against text: %s" % [text_in, pending_text])
