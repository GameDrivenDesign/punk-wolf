extends KinematicBody2D

const SPEED = 100.0  
var to_right = true
var position_right = 0
var position_left = 0
var direction

const SPAWN_TIME = 1 #s
var current_spawn = 0

func _ready():
	current_spawn = randf()
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
	if current_spawn >= SPAWN_TIME:
		current_spawn = 0
		var projectile = preload("res://projectiles/Projectile.tscn").instance()
		projectile.position = $ProjectileSpawn.global_position
		get_parent().add_child(projectile)
