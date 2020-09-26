extends Node2D

var enemy_count = 0
var stage_count = 0

func _ready():
	next_stage()

func spawn_enemy(file):
	var enemy = load(file).instance()
	enemy.position = Vector2(rand_range(0, get_viewport_rect().size.x), rand_range(40, 120))
	enemy.connect("killed", self, "enemy_killed")
	add_child(enemy)
	enemy_count += 1
	return enemy

func enemy_killed():
	enemy_count -= 1
	if enemy_count <= 0:
		next_stage()

func next_stage():
	enemy_count = 0
	stage_count += 1
	if stage_count == 1:
		for _i in range(3):
			spawn_enemy("res://wolf.tscn")
	if stage_count == 2:
		for _i in range(56):
			spawn_enemy("res://wolf.tscn")
