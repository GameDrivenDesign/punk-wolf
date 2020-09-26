extends Node2D

const DECAY = 8
const SHIELD_COLOR_TOLERANCE = 0.3
var r = 1
var b = 1

func _ready():
	#$AnimationPlayer.play("open", -1, 8)
	#yield($AnimationPlayer, "animation_finished")
	#queue_free()
	pass

func is_blocked(projectile):
	var projectile_color = projectile.get_modulate()
	var color = get_modulate()
	var shield_vector = Vector3(color.r - 1, color.g - 1, color.b - 1).normalized()
	var projectile_vector = Vector3(projectile_color.r - 1, projectile_color.g - 1, projectile_color.b - 1).normalized()
	return projectile_vector.distance_to(shield_vector) < SHIELD_COLOR_TOLERANCE

func _process(delta):
	if Input.is_action_pressed("shield_red"):
		r += delta * 5
	else:
		r -= delta * DECAY
	
	if Input.is_action_pressed("shield_blue"):
		b += delta * 5
	else:
		b -= delta * DECAY
	r = max(1, min(4, r))
	b = max(1, min(4, b))
	
	set_modulate(Color(r, 1, b))
