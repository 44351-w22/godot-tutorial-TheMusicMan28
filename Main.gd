extends Node

export(PackedScene) var mob_scene
var score
var lives
var high_score = 0

func _ready():
	randomize()

func new_game():
	score = 0
	lives = 3
	$Player.update_lives(lives)
	$Spiral.set_speed_scale(5)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message('Get Ready')
	$Music.play()
	


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation");
	mob_spawn_location.offset = randi()

	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	add_child(mob)

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	
func _on_Player_hit():
	get_tree().call_group('mobs', 'queue_free')
	lives -= 1
	$Player.update_lives(lives)
	if lives <= 0:
		$HUD.update_lives(lives)
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		get_tree().call_group('mobs', 'queue_free')
		$Music.stop()
		$DeathSound.play()
		if (score > high_score):
			high_score = score
			$HUD.update_high_score(high_score)
	else:
		$HUD.update_lives(lives)
		$HUD.show_lives_lost(lives)
		$WilhelmScream.play()
		$Spiral.set_speed_scale($Spiral.get_speed_scale() * 3)
