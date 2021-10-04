extends KinematicBody2D

signal cast

var spell_time : float
var wand_stage : int
var verbose : bool = false

const SPELL_TIMER = 1.0
const INPUT = preload("res://Scripts/Library/input.gd")

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_BACKSPACE:
				var _text = $SpellInput.get_text()
				_text.erase(_text.length() - 1, 1)
				$SpellInput.set_text(_text)
			KEY_ENTER:
				emit_signal("cast", $SpellInput.text)
				spell_time = SPELL_TIMER
				wand_stage = 4
				$SpellInput.set_text("")
			KEY_ESCAPE:
				if verbose:
					print("UI Cancel event handled by pause menu")
			_:
				$SpellInput.text += INPUT.process_input(event)

func _process(delta):
	spell_time -= delta
	# Wand tip fade
	if spell_time <= 0:
		wand_stage = 0
	elif spell_time < (SPELL_TIMER * .3):
		wand_stage = 1
	elif spell_time < (SPELL_TIMER * .6):
		wand_stage = 2
	elif spell_time < (SPELL_TIMER * .9):
		wand_stage = 3
		
	if !$Wand.playing:
		$Wand.set_frame(wand_stage)

func _ready():
	preload("res://Scripts/Library/input.gd")
	$SpellInput.text = ""
	wand_stage = 0
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
