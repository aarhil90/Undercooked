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
	# Ensure all nodes are valid before proceeding
	if not _validate_nodes():
		print("Error: Required nodes not found!")
		return
	
	# Find or create the high score manager
	_setup_high_score_manager()
	
	# Connect signals safely
	_connect_signals()
	
	# Get final score from meta data
	if get_tree().has_meta("final_score"):
		final_score = get_tree().get_meta("final_score")
		get_tree().remove_meta("final_score")
	
	# Set up the scene
	update_display()

func _validate_nodes() -> bool:
	"""Check if all required nodes exist"""
	return (final_score_label != null and 
			name_input != null and 
			submit_button != null and 
			menu_button != null and 
			high_scores_list != null and 
			new_high_score_label != null)

func _setup_high_score_manager():
	"""Find or create the high score manager"""
	high_score_manager = get_tree().get_first_node_in_group("HighScoreManager")
	if not high_score_manager:
		# Create one if it doesn't exist
		var high_score_script = load("res://high_score_scene.gd")
		if high_score_script:
			high_score_manager = high_score_script.new()
			high_score_manager.add_to_group("HighScoreManager")
			get_tree().current_scene.add_child(high_score_manager)
			print("Created new high score manager")
		else:
			print("Error: Could not load high_score_scene.gd")
			return
	else:
		print("Found existing high score manager")

func _connect_signals():
	"""Safely connect all signals"""
	if submit_button and not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)
	
	if menu_button and not menu_button.pressed.is_connected(_on_menu_pressed):
		menu_button.pressed.connect(_on_menu_pressed)
	
	if name_input and not name_input.text_submitted.is_connected(_on_name_submitted):
		name_input.text_submitted.connect(_on_name_submitted)

func set_final_score(score: int):
	"""Set the final score and update display"""
	final_score = score
	update_display()

func update_display():
	"""Update the display with current score and high scores"""
	if not _validate_nodes() or not high_score_manager:
		return
	
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
	if not high_scores_list or not high_score_manager:
		return
	
	# Clear existing scores
	for child in high_scores_list.get_children():
		if is_instance_valid(child):
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
	if not name_input:
		return
	
	var player_name = name_input.text.strip_edges()
	if player_name.length() == 0:
		player_name = "Anonymous"
	
	if player_name.length() > 20:
		player_name = player_name.substr(0, 20)
	
	var position = HighScoreManager.add_high_score(player_name, final_score)
	
	print("Score submitted: ", player_name, " - $", final_score, " (Position: ", position, ")")
	
	# Hide input elements safely
	if new_high_score_label:
		new_high_score_label.visible = false
	if name_input:
		name_input.visible = false
	if submit_button:
		submit_button.visible = false
	
	# Update display
	update_high_scores_display()

func _on_menu_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://menu.tscn")
