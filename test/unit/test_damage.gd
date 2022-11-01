extends GutTest

var scene
var shield
var sheep

func before_each():
	scene = load("res://TestGame.tscn").instance()
	$"/root/".add_child(scene)
	shield = scene.get_node("Sheep/Shield")
	sheep = scene.get_node("Sheep")
	sheep.global_position = Vector2(100, 100)

func after_each():
	scene.queue_free()

func test_damage():
	sheep.hitpoints = 100
	var projectile = preload("res://projectiles/Projectile.tscn").instance()
	watch_signals(projectile)
	projectile.damage = 10
	projectile.set_color(Color.red)
	projectile.global_position = Vector2(100, 100)
	scene.add_child(projectile)
	yield(get_tree().create_timer(0.1), "timeout")
	
	assert_eq(sheep.hitpoints, 90)

func test_shielding_damage():
	sheep.hitpoints = 100
	var projectile = preload("res://projectiles/Projectile.tscn").instance()
	projectile.damage = 10
	projectile.set_color(Color(4, 1, 1, 1))
	projectile.global_position = Vector2(100, 100)
	
	shield.set_modulate(Color(4, 1, 1, 1))
	
	scene.add_child(projectile)
	yield(get_tree().create_timer(0.3), "timeout")
	
	assert_eq(sheep.hitpoints, 100)

func test_shielding_damage_wrong_color():
	sheep.hitpoints = 100
	var projectile = preload("res://projectiles/Projectile.tscn").instance()
	projectile.damage = 10
	projectile.set_color(Color(1, 1, 4, 1))
	projectile.global_position = Vector2(100, 100)
	
	shield.set_modulate(Color(4, 1, 1, 1))
	
	scene.add_child(projectile)
	yield(get_tree().create_timer(0.3), "timeout")
	
	assert_eq(sheep.hitpoints, 90)

