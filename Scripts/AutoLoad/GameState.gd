extends Node

var score: int = 0
var high_score: int = 320
var level: int = 1
var lives: int = 2
var timer := Timer

enum GlobalState {SCATTER, CHASE, SCARE}
var current_global_state := GlobalState.SCATTER

func _ready():
	var timer = Timer.new()
	add_child(timer)
	# if {есть файл с сохранением}:
	#	high_score = open(file).get_high_score()
	#pass

func end_game():
	# Заменить на меню, которое будет открываться и показывать твой лучший счёт
	print('  END GAME\n', '---TITLES---')
	get_tree().quit()

func scared_ghost():
	current_global_state = GlobalState.SCARE
	var _timer := Timer 
