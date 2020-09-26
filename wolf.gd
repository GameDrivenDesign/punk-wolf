extends RigidBody2D

const SPEED = 100.0  
var to_right = true
var position_right = Vector2(800,0)
var position_left = Vector2(0,0)
var direction

func _physics_process(delta):
	if to_right:
		direction = (position_right - position).normalized()
	else: 
		direction = (position_left -position).normalized()
	var motion = direction * SPEED * delta
	position += motion
	if position_right <= position || position_left >= position:
		to_right = not to_right
