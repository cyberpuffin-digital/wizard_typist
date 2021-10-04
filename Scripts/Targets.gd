extends KinematicBody2D

signal hit

# Move across the screen
export var speed : int = 150

var collision : KinematicCollision2D
var explosion : PackedScene
var gamecontroller : Array
var velocity : Vector2

func _exit_tree():
	var explode : Node = explosion.instance()
	print("%s has exploded" % name)
	explode.emitting = true
	explode.transform = transform
	get_parent().add_child(explode)

func _ready():
	explosion = preload("res://Scenes/Explode.tscn")
	gamecontroller = get_tree().get_nodes_in_group("controller")
	$AnimatedSprite.play()

func _physics_process(delta):
	velocity = Vector2.LEFT * speed * delta
	collision = move_and_collide(velocity)

	if collision:
		gamecontroller[0].failed_spell(name)
		emit_signal("hit")
		print("Wizard bumps into ", name)
		queue_free()
