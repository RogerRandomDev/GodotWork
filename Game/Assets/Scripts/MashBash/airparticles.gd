extends CPUParticles2D

func _ready():
	emitting = true
	if get_child_count() > 0:
		$boingword.emitting=true

func _process(_delta):
	if not emitting:
		queue_free()
