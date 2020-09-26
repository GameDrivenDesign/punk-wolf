extends Node2D

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
	var threshold = 1.5
	print(str(color.r) + " : " + str(projectile_color.r))
	return (abs(color.r - projectile_color.r) < threshold) and (abs(color.b - projectile_color.b) < threshold)

func _process(delta):
	r -= delta 
	b -= delta 
	if (Input.is_key_pressed(KEY_R)):
		r += delta * 5
	if (Input.is_key_pressed(KEY_T)):
		b += delta * 5
	r = max(1, min(4, r))
	b = max(1, min(4, b))
	set_modulate(Color(r, 1, b))
