extends Node2D

var gamecontroller : Array
var targets : Array

func _ready():
	# Preload targets in the factory
	targets.append(preload("res://Scenes/Targets/Chair.tscn"))
	targets.append(preload("res://Scenes/Targets/Ghost.tscn"))
	targets.append(preload("res://Scenes/Targets/Skeleton.tscn"))
	targets.append(preload("res://Scenes/Targets/Specter.tscn"))
	targets.append(preload("res://Scenes/Targets/Table.tscn"))
	# TODO: replace dirty manual way with proper auto loader

	# Connect to game controller signals
	gamecontroller = get_tree().get_nodes_in_group("controller")
	gamecontroller[0].connect("target_destroyed", self, "spawn")

func pick_random_scene() -> PackedScene:
	randomize()
	var rand_index : int = randi() % targets.size()
	
	return targets[rand_index]

func spawn():
	var target : PackedScene = pick_random_scene()
	var instance : Node = target.instance()
	print("Spawning new target: ", instance.name)
	get_parent().add_child(instance)
