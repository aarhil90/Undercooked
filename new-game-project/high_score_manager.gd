extends Node

const SAVE_FILE_PATH = "user://high_scores.dat"
const MAX_HIGH_SCORES = 10

var high_scores: Array[Dictionary] = []
var online_high_scores: Node = null

signal scores_loaded
signal score_saved
signal online_scores_updated(scores: Array)

func _ready():
	load_high_scores()
	
	# Initialize online high scores (optional)
	# Uncomment the next lines when you have a backend set up
	# online_high_scores = preload("res://online_high_scores.gd").new()
	# add_child(online_high_scores)
	# online_high_scores.online_scores_loaded.connect(_on_online_scores_loaded)

func load_high_scores():
	"""Load high scores from local file"""
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			
			if parse_result == OK:
				var data = json.data
				if data is Array:
					high_scores = data
					print("Loaded ", high_scores.size(), " high scores")
				else:
					print("Invalid high scores data format")
			else:
				print("Error parsing high scores JSON")
	else:
		print("No high scores file found, starting fresh")
	
	# Ensure high_scores array is properly formatted
	validate_high_scores()
	scores_loaded.emit()

func save_high_scores():
	"""Save high scores to local file"""
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(high_scores)
		file.store_string(json_string)
		file.close()
		print("High scores saved successfully")
		score_saved.emit()
	else:
		print("Error: Could not save high scores")

func add_high_score(player_name: String, score: int) -> int:
	"""Add a new high score and return its position (1-based), or 0 if not in top 10"""
	var new_score = {
		"name": player_name.strip_edges(),
		"score": score,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	# Find insertion position
	var position = -1
	for i in range(high_scores.size()):
		if score > high_scores[i].score:
			position = i
			break
	
	if position == -1 and high_scores.size() < MAX_HIGH_SCORES:
		# Add to end if not full
		position = high_scores.size()
	
	if position != -1:
		high_scores.insert(position, new_score)
		
		# Keep only top scores
		if high_scores.size() > MAX_HIGH_SCORES:
			high_scores = high_scores.slice(0, MAX_HIGH_SCORES)
		
		save_high_scores()
		return position + 1  # Return 1-based position
	
	return 0  # Not in top 10

func get_high_scores() -> Array[Dictionary]:
	"""Get copy of high scores array"""
	return high_scores.duplicate()

func is_high_score(score: int) -> bool:
	"""Check if a score qualifies for the high score table"""
	if high_scores.size() < MAX_HIGH_SCORES:
		return true
	
	return score > high_scores[high_scores.size() - 1].score

func validate_high_scores():
	"""Ensure all high score entries have required fields"""
	var valid_scores = []
	for score_entry in high_scores:
		if score_entry is Dictionary and score_entry.has("name") and score_entry.has("score"):
			if not score_entry.has("timestamp"):
				score_entry["timestamp"] = Time.get_unix_time_from_system()
			valid_scores.append(score_entry)
	
	high_scores = valid_scores
	
	# Sort by score (highest first)
	high_scores.sort_custom(func(a, b): return a.score > b.score)

func submit_online_score(player_name: String, score: int):
	"""Submit score to online leaderboard (if available)"""
	if online_high_scores and online_high_scores.has_method("submit_score_online"):
		online_high_scores.submit_score_online(player_name, score)
	else:
		print("Online high scores not available")

func load_online_scores():
	"""Load online high scores (if available)"""
	if online_high_scores and online_high_scores.has_method("load_online_scores"):
		online_high_scores.load_online_scores()
	else:
		print("Online high scores not available")

func _on_online_scores_loaded(scores: Array):
	"""Handle online scores being loaded"""
	online_scores_updated.emit(scores)