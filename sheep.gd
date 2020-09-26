extends KinematicBody2D

signal hit

export (int) var speed = 200

var velocity = Vector2()
var health = 100

const CANNON_TIMEOUT = 1
var timeout_cannons = [0, 0]

func _ready():
	add_child(preload("res://shield.tscn").instance())

func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	
	if Input.is_action_just_pressed("shoot_0"):
		shoot(0)
	if Input.is_action_just_pressed("shoot_1"):
		shoot(1)
	
	velocity = velocity.normalized() * speed

func shoot(cannon_index):
	if timeout_cannons[cannon_index] <= 0:
		var p = preload("res://projectiles/Projectile.tscn").instance()
		p.rotation_degrees = 180
		p.speed = 1500
		p.target_group = "wolf"
		p.position = global_position
		p.set_modulate(Color(1, 4, 1))
		get_parent().add_child(p)
		timeout_cannons[cannon_index] = CANNON_TIMEOUT

func _physics_process(delta):
	get_input()
	
	timeout_cannons[0] -= delta
	timeout_cannons[1] -= delta
	
	move_and_collide(velocity * delta)

func take_damage(amount, point):
	health -= amount
	emit_signal("hit")
	$"../camera".add_trauma(1)
