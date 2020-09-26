extends KinematicBody2D

signal killed

const SPEED = 200.0  
var to_right = true
var position_right: float = 0
var position_left: float = 0
var direction: Vector2
var hitpoints = 35

var shoot_spread_angle = 0
var shoot_short_interval = 1 #s
var shoot_long_interval = 3 #s
var shoot_spawn_interval = 0.2 #s
var current_spawn: float = 0
#var color_index: int = randi() % 5
var color: Color
var short_time: float = 0

func _ready():
	current_spawn = randf() * 3
	to_right = true if randf() > 0.5 else false
	position_right = get_viewport_rect().size.x - Global.PADDING_HORIZONTAL.y
	position_left = Global.PADDING_HORIZONTAL.x

func _physics_process(delta: float):
	if to_right:
		direction = Vector2(position_right - position.x, 0).normalized()
	else:
		direction = Vector2(position_left - position.x, 0).normalized()
	var motion: Vector2 = direction * SPEED * delta
	position += motion
	if position_right <= position.x || position_left >= position.x:
		to_right = not to_right

	current_spawn += delta
	short_time += delta
	if current_spawn >= shoot_long_interval:
		current_spawn = 0
		short_time = 0
	if current_spawn <= shoot_short_interval:
		if short_time >= shoot_spawn_interval:
			short_time = 0
			
			spawn_projectile()
			if shoot_spread_angle > 0:
				spawn_projectile().rotation_degrees = shoot_spread_angle
				spawn_projectile().rotation_degrees = -shoot_spread_angle
			$LaserPlayer.play()

func spawn_projectile():
	var projectile = preload("res://projectiles/Projectile.tscn").instance()
	projectile.position = $ProjectileSpawn.global_position
	projectile.set_color(color)
	get_parent().add_child(projectile)
	return projectile

func take_damage(damage, point):
	hitpoints -= damage
	
	if hitpoints <= 0:
		var fx = preload("res://projectiles/particles_ship_explodes.tscn").instance()
		fx.position = global_position
		get_parent().add_child(fx)
		queue_free()
		emit_signal("killed")
	else:
		var fx = preload("res://projectiles/particles_deflected.tscn").instance()
		fx.position = point
		fx.rotation_degrees = 180
		get_parent().add_child(fx)
		$ImpactPlayer.play()
