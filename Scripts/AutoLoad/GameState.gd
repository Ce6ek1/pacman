extends Node

signal game_win()
signal game_event(data:String)

var score: int = 0
var high_score: int = 320
var level: int = 1
var lives: int = 2
var spook_timer: Timer
var gs_timer : Timer
var collected_points := 0

enum GlobalState {SCATTER, CHASE}
var current_global_state := GlobalState.SCATTER

func _ready():
	spook_timer = Timer.new()
	add_child(spook_timer)
	spook_timer.wait_time = 8.0
	spook_timer.one_shot = true
	spook_timer.timeout.connect(change_ghost_state)
	gs_timer = Timer.new()
	add_child(gs_timer)
	gs_timer.one_shot = true
	gs_timer.timeout.connect(_game_state_timer_timeout)
	start_game_state_timer()

func end_game():
	# Заменить на меню, которое будет открываться и показывать твой лучший счёт
	print('  END GAME\n', '---TITLES---')
	get_tree().quit()

func scare_ghost():
	spook_timer.start()

func change_ghost_state():
	game_event.emit('from_spook_to_normal')

func check_for_win():
	if collected_points == 244:
		print('КОНЕЦ ИГРЫ')
		game_win.emit()


func start_game_state_timer():
	gs_timer.wait_time = get_random_wait_time()
	print('Timer запущен на ', gs_timer.wait_time, ' секунд!')
	gs_timer.start()

func _game_state_timer_timeout():
	if current_global_state == GlobalState.SCATTER:
		current_global_state = GlobalState.CHASE
	else:
		current_global_state = GlobalState.SCATTER
	game_event.emit('change_state')
	start_game_state_timer()


func get_random_wait_time():
	if current_global_state == GlobalState.CHASE:
		return max (randf_range(25, 40), score / 20)
	elif current_global_state == GlobalState.SCATTER:
		return max(randf_range(4, 7) - score / 750, 0.5)
