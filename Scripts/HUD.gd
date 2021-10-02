extends RichTextLabel

var accuracy_value : Label
var death_clock_value : Label
var gamecontroller : Array
var score_value : Label

func _ready():
	accuracy_value = get_node("Score/Value")
	death_clock_value = get_node("Score/Value")
	score_value = get_node("Score/Value")
	
	gamecontroller = get_tree().get_nodes_in_group("controller")
	gamecontroller[0].connect("target_destroyed", self, "spawn")
