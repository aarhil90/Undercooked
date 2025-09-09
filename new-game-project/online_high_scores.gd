extends Node

# Online high score options for Godot games:

"""
OPTION 1: Firebase Realtime Database (Recommended for beginners)
- Free tier: 1GB storage, 10GB transfer/month
- Real-time updates
- Easy setup with REST API
- Good for small to medium games

OPTION 2: Supabase (Open source Firebase alternative)
- Free tier: 500MB database, 1GB bandwidth
- PostgreSQL backend
- REST API + real-time subscriptions
- More developer-friendly

OPTION 3: Custom Backend (Most flexible)
- Use Node.js, Python Flask/Django, or PHP
- Host on services like Vercel, Railway, or DigitalOcean
- Full control over data and features

OPTION 4: Lootlocker (Game-specific)
- Free tier: 1000 players, 10GB storage
- Built specifically for games
- Leaderboards, player management
- Easy Godot integration

IMPLEMENTATION EXAMPLE BELOW:
This uses a simple HTTP POST/GET to a hypothetical backend.
Replace the URL with your actual backend endpoint.
"""

const API_BASE_URL = "https://your-backend.com/api"  # Replace with your backend
const GAME_ID = "undercooked_v1"  # Unique identifier for your game

var http_request: HTTPRequest

signal online_scores_loaded(scores: Array)
signal score_submitted(success: bool, message: String)

func _ready():
	# Create HTTP request node
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

var current_request_type: String = ""

func submit_score_online(player_name: String, score: int):
	"""Submit score to online leaderboard"""
	var url = API_BASE_URL + "/scores"
	var headers = ["Content-Type: application/json"]
	var data = {
		"game_id": GAME_ID,
		"player_name": player_name,
		"score": score,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	current_request_type = "submit"
	var json_string = JSON.stringify(data)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_string)
	
	if error != OK:
		print("Error submitting score: ", error)
		score_submitted.emit(false, "Network error")

func load_online_scores(limit: int = 10):
	"""Load top scores from online leaderboard"""
	var url = API_BASE_URL + "/scores?game_id=" + GAME_ID + "&limit=" + str(limit)
	
	current_request_type = "load"
	var error = http_request.request(url)
	
	if error != OK:
		print("Error loading scores: ", error)
		online_scores_loaded.emit([])

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	"""Handle HTTP request completion"""
	var response_text = body.get_string_from_utf8()
	print("HTTP Response: ", response_code, " - ", response_text)
	
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		
		if parse_result == OK:
			var data = json.data
			
			if current_request_type == "submit":
				score_submitted.emit(true, "Score submitted successfully!")
			elif current_request_type == "load":
				if data is Array:
					online_scores_loaded.emit(data)
				else:
					online_scores_loaded.emit([])
		else:
			print("JSON parse error: ", json.error_string)
			if current_request_type == "submit":
				score_submitted.emit(false, "Server response error")
			elif current_request_type == "load":
				online_scores_loaded.emit([])
	else:
		print("HTTP error: ", response_code)
		if current_request_type == "submit":
			score_submitted.emit(false, "Server error: " + str(response_code))
		elif current_request_type == "load":
			online_scores_loaded.emit([])

"""
SIMPLE BACKEND EXAMPLE (Node.js + Express):

const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const app = express();

app.use(express.json());
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', '*');
	res.header('Access-Control-Allow-Headers', 'Content-Type');
	res.header('Access-Control-Allow-Methods', 'GET, POST');
	next();
});

const db = new sqlite3.Database('scores.db');

// Create table
db.run(`CREATE TABLE IF NOT EXISTS scores (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	game_id TEXT,
	player_name TEXT,
	score INTEGER,
	timestamp INTEGER
)`);

// Submit score
app.post('/api/scores', (req, res) => {
	const { game_id, player_name, score, timestamp } = req.body;
	
	db.run('INSERT INTO scores (game_id, player_name, score, timestamp) VALUES (?, ?, ?, ?)',
		[game_id, player_name, score, timestamp],
		function(err) {
			if (err) {
				res.status(500).json({ error: err.message });
			} else {
				res.json({ id: this.lastID });
			}
		});
});

// Get scores
app.get('/api/scores', (req, res) => {
	const { game_id, limit = 10 } = req.query;
	
	db.all('SELECT player_name, score, timestamp FROM scores WHERE game_id = ? ORDER BY score DESC LIMIT ?',
		[game_id, parseInt(limit)],
		(err, rows) => {
			if (err) {
				res.status(500).json({ error: err.message });
			} else {
				res.json(rows);
			}
		});
});

app.listen(3000, () => {
	console.log('High score server running on port 3000');
});

DEPLOYMENT:
1. Deploy this to Railway, Vercel, or DigitalOcean
2. Update API_BASE_URL in this script
3. Your high scores will be shared globally!
"""
