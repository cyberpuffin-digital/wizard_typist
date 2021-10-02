extends KinematicBody2D

signal hit

# Move across the screen
export var speed : int = 150

var collision : KinematicCollision2D
var gamecontroller : Array
var velocity : Vector2

func _ready():	
	gamecontroller = get_tree().get_nodes_in_group("controller")
	gamecontroller[0].connect("target_destroyed", self, "spawn")
	pass

func _physics_process(delta):
	velocity = Vector2.LEFT * speed * delta
	collision = move_and_collide(velocity)

	if collision:
		emit_signal("hit")
		
		print("Wizard bumps into ", name) # collision.collider)
		# TODO: fireworks
		free()
