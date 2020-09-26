extends Area2D
const DIRECTION = Vector2.DOWN

var speed = 800
var damage = 10
var target_group = "sheep"
var b = Color(1, 1, 7)
var r = Color(4, 1, 1)
var rb = Color(3.5, 1, 3.5)
var rrb = Color(4, 1, 2)
var rbb = Color(2, 1, 5)
var colors = [r, b, rb, rrb, rbb]

func set_color(i):
	set_modulate(colors[i])

func _physics_process(delta):
	position += (transform.y.normalized() * delta * speed)

func _on_Projectile_body_entered(body):
	if body.is_in_group(target_group):
		body.take_damage(damage)
		queue_free()

func _on_Projectile_area_entered(area):
	if area.is_in_group("shield") and target_group == 'sheep':
		if area.is_blocked(self):
			var fx = preload("res://projectiles/particles_deflected.tscn").instance()
			fx.position = global_position
			get_parent().add_child(fx)
			queue_free()
