extends Control

@onready var final_score_label: Label = $VBoxContainer/FinalScoreLabel
@onready var name_input: LineEdit = $VBoxContainer/NameInput
@onready var submit_button: Button = $VBoxContainer/HBoxContainer/SubmitButton
@onready var menu_button: Button = $VBoxContainer/HBoxContainer/MenuButton
@onready var high_scores_list: VBoxContainer = $VBoxContainer/ScrollContainer/HighScoresList
@onready var new_high_score_label: Label = $VBoxContainer/NewHighScoreLabel

var final_score: int = 0
var high_score_manager: Node

func _ready():
	# Find the high score manager
	high_score_manager = get_tree().get_first_node_in_group("HighScoreManager")
	if not high_score_manager:
		# Create one if it doesn't exist
		high_score_manager = preload("res://high_score_manager.gd").new()
		high_score_manager.add_to_group("HighScoreManager")
		get_tree().current_scene.add_child(high_score_manager)
	
	# Connect signals
	submit_button.pressed.connect(_on_submit_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	name_input.text_submitted.connect(_on_name_submitted)
	
	# Get final score from meta data
	if get_tree().has_meta("final_score"):
		final_score = get_tree().get_meta("final_score")
		get_tree().remove_meta("final_score")
	
	# Set up the scene
	update_display()

func set_final_score(score: int):
	"""Set the final score and update display"""
	final_score = score
	update_display()

func update_display():
	"""Update the display with current score and high scores"""
	if final_score > 0:
		final_score_label.text = "Final Score: $" + str(final_score)
		
		# Check if it's a high score
		if high_score_manager.is_high_score(final_score):
			new_high_score_label.text = "🎉 NEW HIGH SCORE! 🎉"
			new_high_score_label.visible = true
			name_input.visible = true
			submit_button.visible = true
			name_input.grab_focus()
		else:
			new_high_score_label.visible = false
			name_input.visible = false
			submit_button.visible = false
	
	# Display current high scores
	update_high_scores_display()

func update_high_scores_display():
	"""Update the high scores list display"""
	# Clear existing scores
	for child in high_scores_list.get_children():
		child.queue_free()
	
	# Add current high scores
	var scores = high_score_manager.get_high_scores()
	for i in range(scores.size()):
		var score_entry = scores[i]
		var label = Label.new()
		label.text = str(i + 1) + ". " + score_entry.name + " - $" + str(score_entry.score)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		high_scores_list.add_child(label)
	
	# If no scores yet
	if scores.size() == 0:
		var label = Label.new()
		label.text = "No high scores yet!"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		high_scores_list.add_child(label)

func _on_submit_pressed():
	"""Handle submit button press"""
	_submit_score()

func _on_name_submitted(text: String):
	"""Handle name input submission (Enter key)"""
	_submit_score()

func _submit_score():
	"""Submit the high score"""
	var player_name = name_input.text.strip_edges()
	if player_name.length() == 0:
		player_name = "Anonymous"
	
	if player_name.length() > 20:
		player_name = player_name.substr(0, 20)
	
	var position = high_score_manager.add_high_score(player_name, final_score)
	
	print("Score submitted: ", player_name, " - $", final_score, " (Position: ", position, ")")
	
	# Hide input elements
	new_high_score_label.visible = false
	name_input.visible = false
	submit_button.visible = false
	
	# Update display
	update_high_scores_display()

func _on_menu_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://menu.tscn")
