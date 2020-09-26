extends Node2D

const DECAY = 8
const SHIELD_COLOR_TOLERANCE = 0.5
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
	var shield_vector = Vector3(color.r, color.g, color.b).normalized()
	var projectile_vector = Vector3(projectile_color.r, projectile_color.g, projectile_color.b).normalized()
	return projectile_vector.distance_to(shield_vector) < SHIELD_COLOR_TOLERANCE

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		r += delta * 5
	else:
		r -= delta * DECAY
	
	if Input.is_key_pressed(KEY_T):
		b += delta * 5
	else:
		b -= delta * DECAY
	r = max(1, min(4, r))
	b = max(1, min(4, b))
	set_modulate(Color(r, 1, b))
