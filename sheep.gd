extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var health = 100

func _ready():
	add_child(preload("res://shield.tscn").instance())

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_just_pressed("ui_up"):
		var p = preload("res://projectiles/Projectile.tscn").instance()
		p.rotation_degrees = 180
		p.target_group = "wolf"
		p.position = global_position
		p.set_modulate(Color(1, 4, 1))
		get_parent().add_child(p)
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_collide(velocity * delta)

func take_damage(amount):
	health -= amount
	$"../camera".add_trauma(1)
