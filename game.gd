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
	# update_score(-10)
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
	if stage_count == 1:
		for _i in range(3):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 15
	elif stage_count == 2:
		for _i in range(6):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_long_interval = 0.9
			e.shoot_spawn_interval = 0.1
	elif stage_count == 3:
		for _i in range(4):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 5
			e.shoot_long_interval = 0.9
			e.shoot_spawn_interval = 0.1
	elif stage_count == 4:
		for _i in range(9):
			var e = spawn_enemy("res://wolf.tscn")
			e.shoot_spread_angle = 2
			e.shoot_long_interval = 2
			e.shoot_spawn_interval = 0.05
	else:
		gameover()

func gameover():
	Global.highscore = score
	get_tree().change_scene("res://gameover.tscn")
