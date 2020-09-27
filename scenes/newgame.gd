extends Node2D

const FADE_DURATION = 0.5 #s

func _input(event):
	if event is InputEventKey:
		Global.useFourColors = $FourColorsCheckBox.pressed
		Global.useAutoCrits = $AutoCritCheckBox.pressed
		var err = get_tree().change_scene("res://game.tscn")
		if err != OK:
			print(err)

func _ready():
	$FourColorsCheckBox.pressed = Global.useFourColors
	$AutoCritCheckBox.pressed = Global.useAutoCrits
	get_current_highscore()
	$Music/StartPlayer.connect("finished", $Music/LoopPlayer, "play")

func _process(delta):
	# fade_music_if_needed(delta)
	pass

func get_current_highscore():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var url = ("https://scores.tmbe.me/score?game=" + Global.GAME_NAME.percent_encode())
	
	if http_request.request(url, [], true, HTTPClient.METHOD_GET) != OK:
		print("Loading highscore failed")
		return -1
	var response = yield(http_request, "request_completed")
	if response[1] != 200:
		print("Loading highscore returned " + str(response[1]))
		return -1
	remove_child(http_request)
	
	var data = JSON.parse(response[3].get_string_from_utf8()).result[0]
	$Current.text = "Current Highscore:\n    " + data["player"] + "    " + str(data["score"])

func fade_music_if_needed(_delta):
	var start = $Music/StartPlayer
	var loop = $Music/LoopPlayer
	
	if loop.volume_db >= 0.0:
		# finished
		return
		
	var pos = start.get_playback_position()
	var full = 48.0
	
	if not loop.playing:
		if full - pos < 4.0:
			loop.play(19.2 - (full - pos))
		
	if start.volume_db >= 0.0 && start.get_playback_position() < full / 2.0:
		return
	
	var progress = (pos - (full - FADE_DURATION)) / FADE_DURATION
	
	if progress < -50:
		progress = 1.0
	
	print(progress)
		
	var clamped = clamp(progress, 0.0, 1.0) # since it's started far before the actual fading should happen, this needs to be clamped
	start.volume_db = -pow(2.0, clamped * 4.0) + 1.0
	loop.volume_db = -pow(2.0, (1.0 - clamped) * 4.0) + 1.0
