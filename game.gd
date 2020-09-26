extends Node2D

var enemy_count = 0
var stage_count = 0
var score: int = 0

func _ready():
	stage_count = 0
	next_stage()
	var err = $Sheep.connect("hit", self, "sheep_hit")
	if (err != OK):
		print(err)

func spawn_enemy(file):
	var enemy = load(file).instance()
	enemy.position = Vector2(
		rand_range(Global.PADDING_HORIZONTAL.x, get_viewport_rect().size.x - Global.PADDING_HORIZONTAL.y),
		rand_range(Global.PADDING_TOP, Global.PADDING_TOP + 120))
	enemy.connect("killed", self, "enemy_killed")
	add_child(enemy)
	enemy_count += 1
	return enemy

func enemy_killed():
	enemy_count -= 1
	update_score(300)
	if enemy_count <= 0:
		call_deferred("next_stage")

func sheep_hit():
	update_score(-1)
	update_hitpoints()

func update_score(delta):
	score += delta
	$camera/CanvasLayer/score.text = str(score).pad_zeros(7)

func update_hitpoints():
	if $Sheep.hitpoints < 0:
		gameover()
	else:
		$camera/CanvasLayer/hitpoints.rect_scale.x = float($Sheep.hitpoints) / $Sheep.max_hitpoints

func next_stage():
	enemy_count = 0
	stage_count += 1
	
	$camera/CanvasLayer/readyLabel.visible = true
	yield(get_tree().create_timer(2), "timeout")
	$camera/CanvasLayer/readyLabel.visible = false
	
	if stage_count == 1:
		var colors = [Global.r, Global.rb, Global.r, Global.rbb]
		var positions = [150, 400, 700, 780]
		for i in range(4):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 15
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 2:
		var colors = [Global.r, Global.rb, Global.rb, Global.rbb, Global.b, Global.rrb]
		var positions = [150, 400, 700, 780, 600, 300]
		for i in range(6):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_long_interval = 0.9
			e.shoot_spawn_interval = 0.1
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 3:
		var colors = [Global.rb, Global.rrb, Global.rb, Global.rbb]
		var positions = [200, 400, 600, 800]
		for i in range(4):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 5
			e.shoot_long_interval = 0.9
			e.shoot_spawn_interval = 0.1
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 4:
		var colors = [Global.r, Global.rrb, Global.rb, Global.rbb, Global.b, Global.rbb, Global.rb, Global.rrb, Global.r]
		var positions = [100, 200, 300, 400, 500, 600, 700, 800, 900]
		for i in range(9):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 2
			e.shoot_long_interval = 2
			e.shoot_spawn_interval = 0.05
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 5:
		var positions = [200, 400, 500, 700, 800]
		var colors = [Global.rrb, Global.rbb, Global.rbb, Global.rrb, Global.r]
		for i in range(5):
			var e = spawn_enemy("res://wolf.tscn")
			e.hitpoints = 200
			e.shoot_spawn_interval = 0.5
			e.shoot_damage = 30
			e.shoot_projectile_speed = 400
		positions = [200, 400, 500, 700]
		colors = [Global.rrb, Global.rbb, Global.rrb, Global.r]
		for i in range(4):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 5
			e.shoot_long_interval = 0.9
			e.shoot_spawn_interval = 0.1
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	else:
		gameover()

func gameover():
	Global.highscore = score
	get_tree().change_scene("res://gameover.tscn")
