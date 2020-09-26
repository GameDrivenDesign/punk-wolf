extends Node2D

func _ready():
	$AnimationPlayer.play("open", -1, 8)
	yield($AnimationPlayer, "animation_finished")
	queue_free()
