extends Node2D

var last_choice = "" 
var game_state = "start"

func _ready():
	var locale = ProjectSettings.get_setting("locale/current") if ProjectSettings.has_setting("locale/current") else "en"
	TranslationServer.set_locale(locale)
	update_ui_texts()
	setup_option_button(locale)
	update_game_texts()
	randomize()
	
func setup_option_button(locale):
	$OptionButton.selected = 1 if locale == "pl" else 0

func update_game_texts():
	if game_state == "start":
		$Winner.text = tr("START_TEXT")
	elif game_state == "player_wins":
		$Winner.text = tr("PLAYERWIN")
	elif game_state == "computer_wins":
		$Winner.text = tr("COMPWIN")
	elif game_state == "draw":
		$Winner.text = tr("DRAW")

func computer_choice():
	var random = randi() % 3
	if random == 0:
		return "rock"
	elif random == 1:
		return "paper"
	return "scissors"
	
func getRockTrue():
	$Rock.visible = true
	$PaperIdle.visible = false
	$Paper.visible = false
	$Scissors.visible = false
	$Rock2.visible = true
	$Paper2Idle.visible = false
	$Paper2.visible = false
	$Scissors2.visible = false
	$Winner.text = str("")

func _on_btn_paper_pressed():
	getRockTrue()
	handle_button_press("paper")

func _on_btn_rock_pressed():
	getRockTrue()
	handle_button_press("rock")

func _on_btn_scissors_pressed():
	getRockTrue()
	handle_button_press("scissors")

func handle_button_press(button_type):
	last_choice = button_type
	$AnimationPlayer.play("start_the_game")

func set_visibility_based_on_choice():
	$Rock.visible = false
	$PaperIdle.visible = false
	$Scissors.visible = false
	
	match last_choice:
		"rock":
			$Rock.visible = true
		"paper":
			$Paper.visible = true
		"scissors":
			$Scissors.visible = true
			
func set_computer_visibility(computer_choice):
	$Rock2.visible = false
	$Paper2Idle.visible = false
	$Scissors2.visible = false

	match computer_choice:
		"rock":
			$Rock2.visible = true
		"paper":
			$Paper2.visible = true
		"scissors":
			$Scissors2.visible = true

func determine_winner(player, computer):
	if player == computer:
		#$Winner.text = str("Draw")
		game_state = "draw"
		$Winner.text = tr("DRAW")
		$drawsound.play()
	elif (player == "rock" && computer == "scissors") || (player == "scissors" && computer == "paper") || (player == "paper" && computer == "rock"):
		#$Winner.text = str("Player has won")
		game_state = "player_wins"
		$Winner.text = tr("PLAYERWIN")
		var score = int($Score.text) + 1
		$Score.text = str(score)
		$winsound.play()
	else:
		#$Winner.text = str("Computer has won")
		game_state = "computer_wins"
		$Winner.text = tr("COMPWIN")
		var score = int($Score2.text) + 1
		$Score2.text = str(score)
		$losesound.play()

func _on_animation_player_animation_finished(anim_name):
	set_visibility_based_on_choice()
	var choice = computer_choice()
	set_computer_visibility(choice)
	determine_winner(last_choice, choice)

func _on_btn_reset_pressed():
	get_tree().reload_current_scene()

func _on_option_button_item_selected(index):
	if index == 1:
		TranslationServer.set_locale("pl")
		ProjectSettings.set_setting("locale/current", "pl")
	else:
		TranslationServer.set_locale("en")
		ProjectSettings.set_setting("locale/current", "en")
	update_ui_texts()
	update_game_texts()

func update_ui_texts():
	$Winner.text = tr("START_TEXT")
	$btnRock.text = tr("ROCK")
	$btnPaper.text = tr("PAPER")
	$btnScissors.text = tr("SCISSORS")
