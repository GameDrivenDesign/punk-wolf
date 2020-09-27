extends Node

const PADDING_HORIZONTAL: Vector2 = Vector2(250, 300)
const PLAYER_PADDING_HORIZONTAL: Vector2 = Vector2(400, 480)
const PADDING_TOP: float = 80.0
const GAME_NAME = "Punk Wolf"

const w = Color(3, 3, 3)
const b = Color(1, 1, 7)
const r = Color(4, 1, 1)
const rb = Color(3.5, 1, 3.5)

const useFourColors = false

const _rrb = Color(4, 1, 2)
const _rbb = Color(2.5, 1, 4.5)
var rbb = _rbb setget ,get_rbb
var rrb = _rrb setget ,get_rrb

var PROJECTILE_COLORS = [r, b, rb, rrb, rbb]

func get_rbb():
	return w if useFourColors else _rbb
func get_rrb():
	return w if useFourColors else _rrb

var highscore = 0
