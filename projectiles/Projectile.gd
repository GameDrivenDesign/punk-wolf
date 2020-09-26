extends Area2D
const DIRECTION = Vector2.DOWN
const SPEED = 600
const DAMAGE = 10

var b = Color(1, 1, 7)
var r = Color(4, 1, 1)
var rb = Color(3.5, 1, 3.5)
var rrb = Color(4, 1, 2)
var rbb = Color(2, 1, 5)
var colors = [r, b, rb, rrb, rbb]

func set_color(i):
	set_modulate(colors[i])

func _physics_process(delta):
	position += (DIRECTION * delta * SPEED)

func _on_Projectile_body_entered(body):
	if body.is_in_group("sheep"):
		body.take_damage(DAMAGE)
		queue_free()


func _on_Projectile_area_entered(area):
	if area.is_in_group("shield"):
		if area.is_blocked(self):
			queue_free()
