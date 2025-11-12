extends Node2D

@onready var live_count: HBoxContainer = $CanvasLayer/LivesAndFruits/LivesContainer
@onready var score_label: Label = $CanvasLayer/Score/HBoxContainer/ScoreContainer/ScorePoint
@onready var high_score_label: Label = $CanvasLayer/Score/HBoxContainer/HighScoreContainer/HighScorePoint


func _process(_delta):
	score_label.text = str(GameState.score)
	if GameState.high_score < GameState.score:
		high_score_label.text = str(GameState.score)
		

func _ready():
	score_label.text = str(GameState.score)
	high_score_label.text = str(GameState.high_score)
	$Map.add_to_group("map")
	#$GameInfo.add_to_group('game_info')

func change_live_count():
	GameState.lives -= 1
	live_count.delete_one_live_sprite()
	
