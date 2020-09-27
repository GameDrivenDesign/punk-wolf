extends Node2D

const DECAY = 8
const SHIELD_COLOR_TOLERANCE = 0.3
var r_index = 0
var b_index = 0
var colors = [1, 2.5, 4, 2.5]

func is_blocked(projectile):
	var projectile_color = projectile.get_modulate()
	var color = get_modulate()
	var shield_vector = Vector3(color.r - 1, color.g - 1, color.b - 1).normalized()
	var projectile_vector = Vector3(projectile_color.r - 1, projectile_color.g - 1, projectile_color.b - 1).normalized()
	return projectile_vector.distance_to(shield_vector) < SHIELD_COLOR_TOLERANCE

func _process(delta):
	if Input.is_action_just_pressed("shield_red"):
		r_index = (r_index + 1) % len(colors)
	
	if Input.is_action_just_pressed("shield_blue"):
		b_index = (b_index + 1) % len(colors)
	
	var r = colors[r_index]
	var b = colors[b_index]
	
	set_modulate(Color(r, 1, b, min(1, r - 1 + b - 1)))
