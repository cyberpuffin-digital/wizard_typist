extends CPUParticles2D

func _ready():
	$Boom.play()

func _process(delta):
	if ! emitting:
		queue_free()
