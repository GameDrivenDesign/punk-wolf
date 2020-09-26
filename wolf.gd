extends KinematicBody2D

const SPEED = 100.0  
var to_right = true
var position_right = 0
var position_left = 0
var direction

const SHORT_TIME = 1#s
const LONG_TIME = 3 #s
const SPAWNINTERVAL = 0.2 #s
var current_spawn = 0
var color_index = randi()%5
var short_time = 0

func _ready():
	current_spawn = randf() * 3
	to_right = true if randf() > 0.5 else false
	position_right = get_viewport_rect().size.x

func _physics_process(delta):
	if to_right:
		direction = Vector2(position_right - position.x, 0).normalized()
	else: 
		direction = Vector2(position_left - position.x, 0).normalized()
	var motion = direction * SPEED * delta
	position += motion
	if position_right <= position.x || position_left >= position.x:
		to_right = not to_right

	current_spawn += delta
	short_time += delta
	if current_spawn >= LONG_TIME:
		current_spawn = 0
		short_time = 0
	if current_spawn <= SHORT_TIME:
		if short_time >= SPAWNINTERVAL:
			short_time = 0
			var projectile = preload("res://projectiles/Projectile.tscn").instance()
			projectile.position = $ProjectileSpawn.global_position
			projectile.set_color(color_index)
			get_parent().add_child(projectile)
