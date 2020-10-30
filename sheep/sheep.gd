extends KinematicBody2D

signal hit
signal blocked

export (int) var speed = 300

var velocity = Vector2()
const max_hitpoints = 500
var hitpoints = max_hitpoints

const CANNON_TIMEOUT = 1
const TWOSHOT_INTERVAL = 0.1
var timeout_cannons = [0, 0]
var last_projectile

var is_moving_left = false
var is_moving_right = false

func _ready():
	$Shield.connect("blocked", self, "emit_signal", ["blocked"])

func _move():
	velocity = Vector2()
	var left_border = Global.PLAYER_PADDING_HORIZONTAL.x
	var right_border = get_viewport_rect().size.x - Global.PLAYER_PADDING_HORIZONTAL.y
	
	if is_moving_right && position.x < right_border:
		velocity.x += 1
		
	if is_moving_left && position.x > left_border:
		velocity.x -= 1
		
	velocity = velocity.normalized() * speed
			
	if (is_moving_right && position.x >= right_border) || (is_moving_left && position.x <= left_border):
		if not $RobotSheepPlayer.playing:
			$RobotSheepPlayer.play()

func _input(_event):
	if Input.is_action_pressed("ui_right"):
		is_moving_right = true
	else:
		is_moving_right = false
	
	if Input.is_action_pressed('ui_left'):
		is_moving_left = true
	else:
		is_moving_left = false

	if Input.is_action_just_pressed("shoot_0"):
		shoot(0)
	if Input.is_action_just_pressed("shoot_1") and not Global.useAutoCrits:
		shoot(1)

func was_shot_recently(cannon_index):
	return Global.useAutoCrits or timeout_cannons[cannon_index] >= CANNON_TIMEOUT - TWOSHOT_INTERVAL

func shoot(cannon_index):
	if timeout_cannons[cannon_index] <= 0:
		var p = preload("res://projectiles/Projectile.tscn").instance()
		p.rotation_degrees = 180
		p.speed = 2500
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
	_move()
	timeout_cannons[0] -= delta
	timeout_cannons[1] -= delta
	
# warning-ignore:return_value_discarded
	move_and_collide(velocity * delta)

func take_damage(amount, _point):
	hitpoints -= amount
	emit_signal("hit")
	$"../camera".add_trauma(1)
	$ImpactPlayer.play()
