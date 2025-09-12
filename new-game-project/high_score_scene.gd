extends Node

# High Score Manager - handles saving and loading high scores

const SAVE_FILE = "user://high_scores.save"
const MAX_HIGH_SCORES = 10

var high_scores = []

func _ready():
	load_high_scores()

func is_high_score(score: int) -> bool:
	"""Check if the given score qualifies as a high score"""
	if high_scores.size() < MAX_HIGH_SCORES:
		return true
	
	# Check if score is higher than the lowest high score
	for entry in high_scores:
		if score > entry.score:
			return true
	
	return false

func add_high_score(player_name: String, score: int) -> int:
	"""Add a high score and return its position (1-based)"""
	var new_entry = {"name": player_name, "score": score}
	
	# Find the correct position to insert
	var position = high_scores.size()
	for i in range(high_scores.size()):
		if score > high_scores[i].score:
			position = i
			break
	
	# Insert at the correct position
	high_scores.insert(position, new_entry)
	
	# Keep only the top scores
	if high_scores.size() > MAX_HIGH_SCORES:
		high_scores.resize(MAX_HIGH_SCORES)
	
	save_high_scores()
	return position + 1  # Return 1-based position

func get_high_scores() -> Array:
	"""Get the array of high scores"""
	return high_scores.duplicate()

func clear_high_scores():
	"""Clear all high scores"""
	high_scores.clear()
	save_high_scores()

func save_high_scores():
	"""Save high scores to file"""
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if save_file:
		var save_data = {"high_scores": high_scores}
		save_file.store_string(JSON.stringify(save_data))
		save_file.close()
	else:
		print("Error: Could not save high scores")

func load_high_scores():
	"""Load high scores from file"""
	if not FileAccess.file_exists(SAVE_FILE):
		print("No high scores file found, starting fresh")
		return
	
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if save_file:
		var json_string = save_file.get_as_text()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var save_data = json.data
			if save_data.has("high_scores"):
				high_scores = save_data.high_scores
			else:
				print("Invalid save file format")
		else:
			print("Error parsing save file: ", json.get_error_message())
	else:
		print("Error: Could not load high scores file")

# Optional: Add a function to get the top score
func get_top_score() -> int:
	"""Get the highest score, or 0 if no scores exist"""
	if high_scores.size() > 0:
		return high_scores[0].score
	return 0

# Optional: Add a function to check if player has any high scores
func player_has_high_score(player_name: String) -> bool:
	"""Check if a player already has a high score"""
	for entry in high_scores:
		if entry.name == player_name:
			return true
	return false


func _on_menu_button_pressed() -> void:
	print ("menu pressed")
	get_tree().change_scene_to_file("res://menu.tscn")
