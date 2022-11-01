extends GutTest

var shield
var scene

const on = 2.5
const off = 1
var sender = InputSender.new(Input)

func before_each():
	scene = load("res://TestGame.tscn").instance()
	$"/root/".add_child(scene)
	scene.get_node("Sheep").position = Vector2(100, 100)
	shield = scene.get_node("Sheep/Shield")

func after_each():
	scene.queue_free()
	sender.release_all()
	sender.clear()

func test_shield():
	assert_true(Global.useFourColors)
	assert_eq(shield.modulate, Color(2.5, 2.5, 2.5, 1))

func test_red_shield():
	assert_true(Global.useFourColors)
	assert_eq(shield.modulate, Color(2.5, 2.5, 2.5, 1))
	sender.action_down("shield_red").hold_for(.5)
	assert_eq(shield.modulate, Color(4, 1, 1, 1))

func test_blue_shield():
	assert_true(Global.useFourColors)
	assert_eq(shield.modulate, Color(2.5, 2.5, 2.5, 1))
	sender.action_down("shield_blue").hold_for(.5)
	assert_eq(shield.modulate, Color(1, 1, 4, 1))

func test_pink_shield():
	assert_true(Global.useFourColors)
	assert_eq(shield.modulate, Color(2.5, 2.5, 2.5, 1))
	sender.action_down("shield_blue").action_down("shield_red").hold_for(.5)
	assert_eq(shield.modulate, Color(4, 1, 4, 1))

func test_shield_reset():
	assert_true(Global.useFourColors)
	assert_eq(shield.modulate, Color(2.5, 2.5, 2.5, 1))
	sender.action_down("shield_blue").hold_for(.2)
	assert_eq(shield.modulate, Color(1, 1, 4, 1))
	yield(sender, 'idle')
	assert_eq(shield.modulate, Color(2.5, 2.5, 2.5, 1))


func test_gain_points_for_right_shields():
	var projectile = preload("res://projectiles/Projectile.tscn").instance()
	projectile.set_color(Color(1, 1, 4, 1))
	projectile.global_position = Vector2(100, 100)
	shield.set_modulate(Color(1, 1, 4, 1))
	watch_signals(shield)
	
	scene.add_child(projectile)
	yield(get_tree().create_timer(0.2), "timeout")
	
	assert_signal_emitted(shield, "blocked")
	assert_gt(scene.score, 0)

func test_lose_points_for_wrong_shields():
	var projectile = preload("res://projectiles/Projectile.tscn").instance()
	projectile.set_color(Color(1, 1, 4, 1))
	projectile.global_position = Vector2(100, 100)
	shield.set_modulate(Color(4, 1, 1, 1))
	watch_signals(shield)
	
	scene.add_child(projectile)
	yield(get_tree().create_timer(0.3), "timeout")
	
	assert_signal_not_emitted(shield, "blocked")
	assert_lt(scene.score, 0)
