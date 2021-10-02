extends Control

signal target_destroyed

export (int) var difficulty = 100

var current_input : String
var current_target : Array
var player : KinematicBody2D
var player_difficulty : int
var target_factory : Node2D
var total_accuracy : int = 0
var total_spell_attempts : int = 0
var total_word_difficult : int = 0

# Track next object instantiated by ObjectFactory
#   If none, signal factory to instantiate a new (timing?)
# Track typing
#   Calculate accuracy and time
#   Signal HUD

func _ready():
	player = get_node("Player")
	player.connect("cast", self, "cast_spell")
	target_factory = get_node("FactoryContainer/ObjectFactory")
	
func _process(delta):
	current_target = get_tree().get_nodes_in_group("target")
	if current_target.size() == 0:
		emit_signal("target_destroyed")

func cast_spell(spell_input : String):
	if current_target.size() == 0:
		print("No available targets")
		return

	var accuracy : int  = check_accuracy(spell_input)
	var word_difficulty : int = check_word_difficulty()
	var target_name : String = current_target[0].name

	print("Cast \"%s\" at \"%s\": %d accurate; %d difficulty" % [
		spell_input, target_name, accuracy, word_difficulty]
	)

	total_accuracy += accuracy
	total_spell_attempts += 1
	total_word_difficult += word_difficulty

	if accuracy > (difficulty / 2):
		print("Spell was successful")
		current_target[0].free()
	else:
		print("Spell fizzled")

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

func check_word_difficulty() -> int:
	if current_target.size() == 0:
		print("No available targets")
		return 0

	return current_target[0].name.length()

func update_hud():
	$HUD/Accuracy/Value.set_text("%d%%" % (total_accuracy / total_spell_attempts))
	$HUD/Score/Value.set_text(String(
		(total_accuracy / total_spell_attempts) * total_word_difficult
	))
	# TODO: Update HUD score
	# TODO: Update HUD death clock
