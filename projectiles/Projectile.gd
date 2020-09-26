extends Area2D
const DIRECTION = Vector2.DOWN
const SPEED = 200
const DAMAGE = 10

func _ready():
	var b = Color(1, 1, 7)
	var r = Color(4, 1, 1)
	var rb = Color(3.5, 1, 3.5)
	var rrb = Color(4, 1, 2)
	var rbb = Color(2, 1, 5)
	var colors = [r, b, rb, rrb, rbb]
	set_modulate(colors[randi()%5])

func _physics_process(delta):
	var coll = move_and_collide(transform.y * delta * SPEED)
	if coll and coll.collider.is_in_group("sheep"):
		coll.collider.take_damage(DAMAGE)
	position += (DIRECTION * delta * SPEED)

func _on_Projectile_body_entered(body):
	if body.is_in_group("sheep"):
		body.take_damage(DAMAGE)
		queue_free()
