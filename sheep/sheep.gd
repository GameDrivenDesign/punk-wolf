extends KinematicBody2D

signal hit

export (int) var speed = 300

var velocity = Vector2()
const max_hitpoints = 500
var hitpoints = max_hitpoints

const CANNON_TIMEOUT = 1
const TWOSHOT_INTERVAL = 0.1
var timeout_cannons = [0, 0]
var last_projectile

func _ready():
	add_child(preload("res://sheep/shield.tscn").instance())

func process_input():
	velocity = Vector2()
	var left_border = Global.PLAYER_PADDING_HORIZONTAL.x
	var right_border = get_viewport_rect().size.x - Global.PLAYER_PADDING_HORIZONTAL.y
	
	if Input.is_action_pressed('ui_right') && position.x < right_border:
		velocity.x += 1
	if Input.is_action_pressed('ui_left') && position.x > left_border:
		velocity.x -= 1
		
	if (Input.is_action_pressed('ui_right') && position.x >= right_border) || (Input.is_action_pressed('ui_left') && position.x <= left_border):
		if not $RobotSheepPlayer.playing:
			$RobotSheepPlayer.play()
		
	if Input.is_action_just_pressed("shoot_0"):
		shoot(0)
	if Input.is_action_just_pressed("shoot_1"):
		shoot(1)
	
	velocity = velocity.normalized() * speed

func was_shot_recently(cannon_index):
	return timeout_cannons[cannon_index] >= CANNON_TIMEOUT - TWOSHOT_INTERVAL

func shoot(cannon_index):
	if timeout_cannons[cannon_index] <= 0:
		var p = preload("res://projectiles/Projectile.tscn").instance()
		p.rotation_degrees = 180
		p.speed = 1500
		p.target_group = "wolf"
		
		if was_shot_recently((cannon_index + 1) % 2):
			p.position = $MiddleSpawnPosition.global_position
			p.scale.y = 4
			p.damage = 50
			p.set_modulate(Color(4, 4, 4))
			
			if last_projectile != null and last_projectile.is_inside_tree():
				last_projectile.queue_free()
			
		else:
			p.position = ($RightProjectileSpawn if cannon_index == 0 else $LeftProjectileSpawn).global_position
			p.set_modulate(Color(1, 4, 1) if cannon_index == 0 else Color(4, 4, 1))
			last_projectile = p
			
		get_parent().add_child(p)
		timeout_cannons[cannon_index] = CANNON_TIMEOUT
		get_node("LaserPlayer" + cannon_index as String).play()


func _physics_process(delta):
	process_input()
	
	timeout_cannons[0] -= delta
	timeout_cannons[1] -= delta
	
# warning-ignore:return_value_discarded
	move_and_collide(velocity * delta)

func take_damage(amount, _point):
	hitpoints -= amount
	emit_signal("hit")
	$"../camera".add_trauma(1)
	$ImpactPlayer.play()
