extends KinematicBody2D
const DIRECTION = Vector2.DOWN
const SPEED = 200

func _physics_process(delta):
	var coll = move_and_collide(DIRECTION * delta * SPEED)
