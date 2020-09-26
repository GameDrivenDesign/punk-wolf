extends Area2D

var speed = 800
var damage = 10
var target_group = "sheep"

#func set_color(i):
#	set_modulate(Global.PROJECTILE_COLORS[i])

func set_color(color:Color):
	set_modulate(color)

func _physics_process(delta):
	position += (transform.y.normalized() * delta * speed)

func _on_Projectile_body_entered(body):
	if body.is_in_group(target_group):
		body.take_damage(damage, position)
		queue_free()

func _on_Projectile_area_entered(area):
	if area.is_in_group("shield") and target_group == 'sheep':
		if area.is_blocked(self):
			var fx = preload("res://projectiles/particles_deflected.tscn").instance()
			fx.position = global_position
			get_parent().add_child(fx)
			queue_free()
