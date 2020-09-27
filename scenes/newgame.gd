extends Node2D

func _input(event):
	if event is InputEventKey:
		var err = get_tree().change_scene("res://game.tscn")
		if err != OK:
			print(err)

func _ready():
	get_current_highscore()

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
