extends Node2D

var enemy_count = 0
var stage_count = 0
var score: int = 0

func _ready():
	next_stage()
	$Sheep.connect("hit", self, "sheep_hit")

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
		next_stage()

func sheep_hit():
	update_score(-10)

func update_score(delta):
	score += delta
	$camera/CanvasLayer/Label.text = str(score).pad_zeros(7)

func next_stage():
	enemy_count = 0
	stage_count += 1
	if stage_count == 1:
		for _i in range(3):
			spawn_enemy("res://wolf.tscn")
	if stage_count == 2:
		for _i in range(56):
			spawn_enemy("res://wolf.tscn")
