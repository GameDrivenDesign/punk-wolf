extends Node2D

const DECAY = 8
const SHIELD_COLOR_TOLERANCE = 0.3
var r_index = 0
var b_index = 0
var colors = [1, 4] if Global.useFourColors else [1, 2.5, 4]

# warning-ignore:unused_signal
signal shield_changed

func is_blocked(projectile):
	var projectile_color = projectile.get_modulate()
	var color = get_modulate()
	var shield_vector = Vector3(color.r - 1, color.g - 1, color.b - 1).normalized()
	var projectile_vector = Vector3(projectile_color.r - 1, projectile_color.g - 1, projectile_color.b - 1).normalized()
	if (Global.useFourColors &&
		projectile_vector.x == projectile_vector.z && projectile_vector.y == projectile_vector.z &&
		shield_vector.x == shield_vector.y && shield_vector.x == shield_vector.z):
		return true
	return projectile_vector.distance_to(shield_vector) < SHIELD_COLOR_TOLERANCE

func _process(_delta):
	if Global.useFourColors:
		r_index = 1 if Input.is_action_pressed("shield_red") else 0
		b_index = 1 if Input.is_action_pressed("shield_blue") else 0
		$"../..".emit_signal("shield_changed", true, r_index)
		$"../..".emit_signal("shield_changed", false, b_index)
	else:
		if Input.is_action_just_pressed("shield_red"):
			r_index = (r_index + 1) % len(colors)
			$"../..".emit_signal("shield_changed", true, r_index)
		if Input.is_action_just_pressed("shield_blue"):
			b_index = (b_index + 1) % len(colors)
			$"../..".emit_signal("shield_changed", false, b_index)
	
	var r = colors[r_index]
	var b = colors[b_index]
	
	set_modulate(Color(r, 1, b, 1.0 if Global.useFourColors else min(1, r - 1 + b - 1)))
