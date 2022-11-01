extends Node2D

# warning-ignore:unused_signal
signal shield_changed

var enemy_count = 0
var stage_count
var score: int = 0

var music_loop_current = 1
var music_loop_fade_active = false
var music_loop_fade_target = 1
const FADE_DURATION = 1.0 #s
const LOOP_DURATION = 2.0 #s, every loop has the same length

func _ready():
	stage_count = -1
	if $Sheep.connect("hit", self, "sheep_hit") != OK:
		pass
	if $Sheep.connect("blocked", self, "sheep_blocked") != OK:
		pass

func _process(delta):
	fade_music_if_needed(delta)

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

func sheep_blocked():
	update_score(1)

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
	
	if stage_count == 0:
		var positions = [100, 200]
		for i in range(2):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_long_interval = 2
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.set_color_change_timeout(2)
	elif stage_count == 1:
		var colors = [Global.r, Global.rb, Global.r, Global.rbb]
		var positions = [150, 400, 700, 780]
		for i in range(4):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_spread_angle = 25
			e.shoot_long_interval = 2
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 2:
		var colors = [Global.r, Global.rb, Global.rb, Global.rbb, Global.b, Global.rrb]
		var positions = [150, 400, 700, 780, 600, 300]
		for i in range(6):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_long_interval = 0.9
			e.shoot_spawn_interval = 0.1
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 3:
		var colors = [Global.rb, Global.rrb, Global.rb, Global.rbb]
		var positions = [200, 400, 600, 800]
		for i in range(4):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_spread_angle = 5
			e.shoot_long_interval = 2
			e.shoot_short_interval = 0.3
			e.shoot_spawn_interval = 0.01
			e.shoot_projectile_speed = 600
			e.change_hitpoints(140)
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
			e.set_color_change_timeout(3)
	elif stage_count == 4:
		var colors = [Global.r, Global.rrb, Global.rb, Global.rbb, Global.b, Global.rbb, Global.rb, Global.rrb, Global.r]
		var positions = [100, 200, 300, 400, 500, 600, 700, 800, 900]
		for i in range(9):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_spread_angle = 2
			e.shoot_long_interval = 2
			e.shoot_spawn_interval = 0.05
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 5:
		var positions = [200, 400, 500, 700, 800]
		var colors = [Global.rrb, Global.rbb, Global.rbb, Global.rrb, Global.r]
		for _i in range(5):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.hitpoints = 200
			e.shoot_long_interval = 2
			e.shoot_spawn_interval = 0.5
			e.shoot_damage = 30
			e.shoot_projectile_speed = 400
		positions = [200, 400, 500, 700]
		colors = [Global.rrb, Global.rbb, Global.rrb, Global.r]
		for i in range(4):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_spread_angle = 5
			e.shoot_long_interval = 1
			e.shoot_spawn_interval = 0.1
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
			e.set_color_change_timeout(5)
	elif stage_count == 6:
		var positions = [200, 300, 400, 500, 600, 700]
		var colors = [Global.rb, Global.rbb, Global.rb, Global.r, Global.rb, Global.rb]
		for i in range(6):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_spread_angle = 30
			e.hitpoints = 120
			e.shoot_long_interval = 1
			e.shoot_spawn_interval = 0.1
			e.position.x = Global.PADDING_HORIZONTAL.x + positions[i]
			e.color = colors[i]
	elif stage_count == 7:
		for _i in range(12):
			var e = spawn_enemy("res://wolf/wolf.tscn")
			e.shoot_long_interval = 1
			e.shoot_damage = 25
			e.shoot_spawn_interval = 0.05
			e.set_color_change_timeout(0.5)
	else:
		gameover()

func gameover():
	Global.highscore = score
	var err = get_tree().change_scene("res://scenes/gameover.tscn")
	if err != OK:
		print(err)

func fade_music_if_needed(_delta):
	if stage_count <= 0 || stage_count - 1 >= len(get_node("Music").get_children()):
		return
	
	# handle active fade
	if music_loop_fade_active:
		var current = get_node("Music").get_child(music_loop_current - 1)
		var target = get_node("Music").get_child(music_loop_fade_target - 1)
		
		var progress = 0.0 # will range from 0.0 to 1.0
		
		var pos = fmod(current.get_playback_position(), 2.0)
		if pos > LOOP_DURATION / 2.0:
			# end of loop
			progress = (pos - (LOOP_DURATION - FADE_DURATION / 2.0)) / FADE_DURATION
		else:
			# already start of new loop
			progress = (pos + FADE_DURATION / 2.0) / FADE_DURATION
			
			
		var clamped = clamp(progress, 0.0, 1.0) # since it's started far before the actual fading should happen, this needs to be clamped
		current.volume_db = -pow(2.0, clamped * 4.0) + 1.0
		target.volume_db = -pow(2.0, (1.0 - clamped) * 4.0) + 1.0
		
		if progress > 1.0:
			music_loop_fade_active = false
			music_loop_current = music_loop_fade_target
	
	# activate fade, if necessary
	if not music_loop_fade_active:
		if music_loop_current != stage_count:
			# only start fade if it wouldn't sound bad
			var current = get_node("Music").get_child(music_loop_current - 1)
			var pos = fmod(current.get_playback_position(), 2.0)
			if pos >= LOOP_DURATION / 2.0 and pos < LOOP_DURATION - FADE_DURATION / 2.0:
				music_loop_fade_target = stage_count
				music_loop_fade_active = true
