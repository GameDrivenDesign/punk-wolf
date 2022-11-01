extends GutTest

var scene
var wolf

func before_each():
	scene = load("res://TestGame.tscn").instance()
	$"/root/".add_child(scene)
	wolf = preload("res://wolf/wolf.tscn").instance()
	scene.add_child(wolf)

func after_each():
	scene.queue_free()

func test_spawn_color():
	wolf.spawn_projectile()
	var projectile = scene.get_node("Projectile")
	assert_eq(wolf.color, projectile.modulate)

func test_spawn_colors():
	wolf.set_color_change_timeout(.2)
	
	wolf.spawn_projectile()
	var projectile = scene.get_node("Projectile")
	assert_eq(wolf.color, projectile.modulate)
	projectile.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	
	wolf.spawn_projectile()
	projectile = scene.get_node("Projectile")
	assert_eq(wolf.color, projectile.modulate)
	projectile.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	
	wolf.spawn_projectile()
	projectile = scene.get_node("Projectile")
	assert_eq(wolf.color, projectile.modulate)
	projectile.queue_free()

