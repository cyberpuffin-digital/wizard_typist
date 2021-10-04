extends Control

signal target_destroyed

export (int) var difficulty = 100

var current_target : Array
var game_over : bool = false
var player : KinematicBody2D
var spell_log : VBoxContainer
var target_factory : Node2D
var total_accuracy : int = 1
var total_spell_attempts : int = 1
var total_word_difficult : int = 0

func _ready():
	player = get_node("Player")
	player.connect("cast", self, "cast_spell")
	spell_log = get_node("ScrollContainer/VBoxContainer")
	target_factory = get_node("FactoryContainer/ObjectFactory")

func _process(delta):
	if game_over:
		gameover()
		return

	current_target = get_tree().get_nodes_in_group("target")
	if current_target.size() == 0:
		emit_signal("target_destroyed")
		
	if total_word_difficult < 0:
		game_over = true

func cast_spell(spell_input : String):
	if current_target.size() == 0:
		print("No available targets")
		return

	var accuracy : int  = check_accuracy(spell_input)
	var word_difficulty : int = check_target_difficulty()
	var target_name : String = current_target[0].name

	# Reset values if they haven't been set yet.
	if total_accuracy == 1:
		total_accuracy = accuracy
		total_spell_attempts = 1
	else:
		total_accuracy += accuracy
		total_spell_attempts += 1

	total_word_difficult += word_difficulty

	if accuracy > (difficulty / 2):
		print("Spell was successful")
		current_target[0].free()
	else:
		print("Spell fizzled")

	update_spell_log(spell_input, target_name, accuracy, word_difficulty * accuracy)
	update_hud()

func check_accuracy(spell_input) -> int:
	var case_match : bool
	var match_count : int = 0
	var score : int = 100
	var spell_char : String
	var target_char : String
	var target_length : int = current_target[0].name.length()
	var value_for_correct_answer : int = score / target_length

	for char_index in range(target_length):
		case_match = false
		spell_char = spell_input.substr(char_index, 1)
		target_char = current_target[0].name.substr(char_index, 1)

		if target_char.casecmp_to(spell_char) == 0:
			print("Exact match")
		elif target_char.nocasecmp_to(spell_char) == 0:
			print("Partial match")
			score -= (value_for_correct_answer / 2)
		else:
			if spell_char in current_target[0].name:
				print("Char is in name, partial credit")
				score -= (value_for_correct_answer / 4)
			else:
				print("Failed match")
				score -= value_for_correct_answer

	return score

func check_target_difficulty() -> int:
	if current_target.size() == 0:
		print("No available targets")
		return 0

	return current_target[0].name.length()

func exit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func failed_spell(target : String):
	total_word_difficult -= target.length()
	update_spell_log_crash(target)
	update_hud()

func gameover():
	get_tree().paused = true
	$GameOver.popup_centered_ratio(0.75)

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func return_to_menu():
	get_tree().change_scene("res://Scenes/Menus/Main_menu.tscn")

func update_spell_log_crash(target: String):
	var crash : Label = Label.new()
	crash.text = "Wizard crashed into \"%s\"" % target
	spell_log.add_child(crash)
	print("Wizard crashed into target \"%s\"" % target)

func update_spell_log(spell: String, target: String, accuracy: int, points: int):
	var action : Label = Label.new()
	action.text = "Wizard cast \"%s\" at \"%s\": %d accuracy; %d points" % [
		spell,
		target,
		accuracy,
		points
	]
	
	spell_log.add_child(action)
	print("Cast \"%s\" at \"%s\": %d accurate; %d points" % [
		spell, target, accuracy, points]
	)

func update_hud():
	$HUD/Accuracy/Value.set_text("%d%%" % (total_accuracy / total_spell_attempts))
	$HUD/Score/Value.set_text(String(
		(total_accuracy / total_spell_attempts) * total_word_difficult
	))
	# TODO: Update HUD death clock
