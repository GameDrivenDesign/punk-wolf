extends KinematicBody2D
const DIRECTION = Vector2.DOWN
const SPEED = 200
const DAMAGE = 10

func _ready():
	#var total = 4
	#var r = 2 if randf() > 0.5 else 4
	#var g = 2 if randf() > 0.5 else 4
	#var b = 2 if randf() > 0.5 else 4
	set_modulate(Color(1, 1, 4))

func _physics_process(delta):
	var coll = move_and_collide(DIRECTION * delta * SPEED)
	if coll and coll.collider.is_in_group("sheep"):
		coll.collider.take_damage(DAMAGE)
		queue_free()
