extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	
func show_lives_lost(lives):
	if lives <= 1:
		show_message("Watch out! " + str(lives) + " Life Left")
		yield($MessageTimer, "timeout")
	else:
		show_message("Watch out! " + str(lives) + " Lives Left")
		yield($MessageTimer, "timeout")
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_high_score(high_score):
	$HighScore.text = str(high_score)
func update_lives(lives):
	$lives.text = str(lives)

func _on_Message_Timer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
