extends Node2D

var loading = false

func _ready():
	$score.text = str(Global.highscore)
	$TextEdit.grab_focus()

# Send a highscore to the server.
# Returns the position on the scoreboard (1-based).
func send_highscore(game: String, player: String, score: int):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var url = ("https://scores.tmbe.me/score?game=" + game.percent_encode() +
		"&player=" + player.percent_encode() +
		"&score=" + str(score).percent_encode())
	
	if http_request.request(url, [], true, HTTPClient.METHOD_POST) != OK:
		print("Sending highscore failed")
		return -1
	var response = yield(http_request, "request_completed")
	if response[1] != 200:
		print("Sending highscore returned " + str(response[1]))
		return -1
	remove_child(http_request)
	
	var position = JSON.parse(response[3].get_string_from_utf8()).result["position"]
	print("Highscore submitted! - You scored position " + str(position))
	get_tree().change_scene("res://scenes/newgame.tscn")
	return position

func send_my_highscore():
	if !loading && len($TextEdit.text) > 0:
		loading = true
		$Button.disabled = true
		send_highscore(Global.GAME_NAME, $TextEdit.text, Global.highscore)

func _on_Button_pressed():
	send_my_highscore()

func _on_TextEdit_text_entered(_new_text):
	send_my_highscore()
