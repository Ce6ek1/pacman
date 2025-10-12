class_name Ghost extends Node2D

enum State {SCATTER, CHASE, FRIGHTENED, EATEN, HOUSED} # Разбрасывание, преследование, испуганный, съединый, сидит в доме 
var current_state = State.SCATTER
@export var position_start_tile: Vector2i
@export var position_scatter_corner: Vector2i
@export var debug: bool = false
@export var paused: bool = true

var timer := Timer.new()
var additional_timer := Timer.new()
var current_direction: Vector2i = Vector2i() #Map
var position_tile_current: Vector2i = Vector2i() #Map
var position_tile_target: Vector2i = Vector2i() #Map
var center_of_current_tile: Vector2i = Vector2i() #Global
var speed: float = 165
var possible_direction: Array = []
var position_tile_next: Vector2i = Vector2i()

const EYES_LEFT = preload("res://Sprites/Ghosts/Eyes/Left.png")
const EYES_RIGHT = preload("res://Sprites/Ghosts/Eyes/Right.png")
const EYES_DOWN = preload("res://Sprites/Ghosts/Eyes/Down.png")
const EYES_UP = preload("res://Sprites/Ghosts/Eyes/Up.png")
const SPECIAL_TILES: Array[Vector2i] = [Vector2i(12, 15), Vector2i(15, 15), Vector2i(15, 27), Vector2i(15, 27)]
const DIR_ARRAY: Array = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.UP]


@onready var mark: Sprite2D = $Mark
@onready var tile_map: TileMapLayer = $'/root/Main/Map'
@onready var pac_man: Node2D = $'/root/Main/Map/PacMan'
@onready var eyes: Sprite2D = $Eyes

func debug_mode():
	mark.visible = true

func _ready():
	create_and_configure_timers()

	global_position = tile_map.map_to_local(position_start_tile)
	add_to_group('ghosts')
	add_to_group('entities')
	if debug:
		debug_mode()
	eyes.scale = Vector2(1.15, 1.15)
	position_tile_current = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(position_tile_current)

func _process(delta):
	if paused:
		#if exit_conditon():
			#paused = false
			#go_to_exit()
		return
	if Input.is_action_just_pressed('test_1'):
		current_state = State.CHASE
	elif Input.is_action_just_pressed('test_2'):
		current_state = State.SCATTER
	set_positions()
	if is_at_center():
		if is_at_turn():
			position_tile_target = select_position_tile_final_target()
		position_tile_next = position_tile_current + choose_best_dir()
	global_position = global_position.move_toward(tile_map.map_to_local(position_tile_next), speed*delta)
	change_eye_texture()
	mark.global_position = tile_map.map_to_local(position_tile_target)
  
func create_and_configure_timers():
	add_child(timer)
	add_child(additional_timer)
	timer.wait_time = pac_man.animation_timer.get_wait_time()
	additional_timer.wait_time = pac_man.additional_timer.get_wait_time()
	timer.timeout.connect(_on_timer_timeout)
	additional_timer.timeout.connect(_on_additional_timeout)
	timer.one_shot = true
	additional_timer.one_shot = true

func is_wall(cell) -> bool:
	var data = tile_map.get_cell_tile_data(cell)
	if data:
		return data.get_custom_data('WALL')
	return false

func is_at_center() -> bool:
	if global_position.distance_to(center_of_current_tile) < 0.5:
		return true
	return false

func is_at_turn():
	if possible_direction.size() >= 0:
		return true
	return false


func set_positions() -> void:
	position_tile_current = tile_map.local_to_map(global_position)
	center_of_current_tile = tile_map.map_to_local(position_tile_current)
	select_possible_direction()

func change_eye_texture():
	match current_direction:
		Vector2i.LEFT:
			eyes.texture = EYES_LEFT
		Vector2i.RIGHT:
			eyes.texture = EYES_RIGHT
		Vector2i.UP:
			eyes.texture = EYES_UP
		Vector2i.DOWN:
			eyes.texture = EYES_DOWN

func select_position_tile_final_target() : #Map
	# Код отличается только в State.CHASE
	match current_state:
		State.CHASE: # Преследование
			return target_on_chase_state()
		State.SCATTER: # Разбегание
			return position_scatter_corner

# Всегда разное у разных приведений
func target_on_chase_state() -> Vector2i:
	push_error('Change the "chase_target" script in the ', name, "'s code")
	return Vector2i(10, 10)

func select_possible_direction() -> Array:
	possible_direction = []
	for dir in DIR_ARRAY:
		if !is_wall(position_tile_current + dir) and dir != -current_direction:
			possible_direction.append(dir)
	return possible_direction

func choose_best_dir() -> Vector2i:
	var dir_best: Vector2i = possible_direction[0] # Направление
	var dist_min: float = INF
	for dir in possible_direction:
		if position_tile_current in SPECIAL_TILES and dir == Vector2i.UP:
			continue
		if position_tile_current + dir in [Vector2i(13, 16), Vector2i(14, 16)]:
			continue
		var next_cell: Vector2i = position_tile_current + dir
		var dist = next_cell.distance_to(position_tile_target)
		if dist < dist_min:
			dir_best = dir
			dist_min = dist

	current_direction = dir_best    
	return dir_best

func respawn():
	set_process(false)
	visible = false
	global_position = tile_map.map_to_local(position_start_tile)
	position_tile_current = tile_map.local_to_map(global_position)
	timer.start()

func _on_timer_timeout():
	visible = true
	additional_timer.start()

func _on_additional_timeout():
	set_process(true)
