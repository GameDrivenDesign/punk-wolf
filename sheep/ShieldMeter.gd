extends ColorRect

export(bool) var isRed = false
const BLACK = Color(0, 0, 0)
const RED = Color(4, 1, 1)
const BLUE = Color(1, 1, 6)
var shieldColor

func _ready():
	shieldColor = RED if isRed else BLUE
	if Global.useFourColors:
		$Top.visible = false
		$Bottom.margin_top = 5
		$Bottom.margin_bottom = 45
		rect_size.y = 50

func _on_game_shield_changed(isRedShield:bool, index:int):
	if isRed != isRedShield:
		return
	if index == 0:
		$Top.color = BLACK
		$Bottom.color = BLACK
	if index == 1 or index == 3:
		$Top.color = BLACK
		$Bottom.color = shieldColor
	if index == 2:
		$Top.color = shieldColor
		$Bottom.color = shieldColor
