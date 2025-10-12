extends Node2D

var current_direction: Vector2i #Map
var position_tile_current: Vector2i #Map
var position_tile_next: Vector2i #Map
var bufferng_direction: Vector2i #Map
var center_of_current_tile: Vector2i #Global
var speed: float = 175
var ghost_array: Array

@onready var animation_timer:= $AnimationTimer
@onready var additional_timer:= $AdditionalTimer
@onready var tile_map: TileMapLayer = $/root/Main/Map
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	# Определяем позицию ПакМена
	set_positions()
	# Определить есть ли в клетке ПакМена призрак
	check_tile()
	# Ввод
	if Input.is_action_pressed('LEFT'):
		bufferng_direction = Vector2i.LEFT
	elif Input.is_action_pressed('RIGHT'):
		bufferng_direction = Vector2i.RIGHT
	elif Input.is_action_pressed('UP'):
		bufferng_direction = Vector2i.UP
	elif Input.is_action_pressed('DOWN'):
		bufferng_direction = Vector2i.DOWN

	# Если по центру клетки, переместить в другую точку
	if is_at_center():
		# Если нет стены в направлении буффера, двигаемся туда
		if !is_wall(position_tile_current + bufferng_direction):
			current_direction = bufferng_direction
		# Если есть стена, то не двигаем ПакМена
		elif is_wall(position_tile_current + current_direction):
			sprite.pause()
			return
		position_tile_next = position_tile_current + current_direction
	move(delta)
	sprite.play()
	



func _ready():
	add_to_group('pacman')
	add_to_group('entities')
	# Выравниваем ПакМена ровно по клетке спавна.
	position_tile_current = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(position_tile_current)

func is_at_center() -> bool:
	if global_position.distance_to(center_of_current_tile) < 2:
		return true
	return false

func is_wall(cell) -> bool:
	var data = tile_map.get_cell_tile_data(cell)
	if data:
		return data.get_custom_data('WALL')
	return false

func set_positions() -> void:
	position_tile_current = tile_map.local_to_map(global_position)
	center_of_current_tile = tile_map.map_to_local(position_tile_current)

func move(multiplier):
	if position_tile_next.x != position_tile_current.x:
		if position_tile_next.x < position_tile_current.x:
			sprite.rotation_degrees = 180
		else:
			sprite.rotation = 0
	elif position_tile_next.y != position_tile_current.y:
		if position_tile_next.y < position_tile_current.y:
			sprite.rotation_degrees = 270
		else:
			sprite.rotation_degrees = 90
	global_position = global_position.move_toward(tile_map.map_to_local(position_tile_next), speed * multiplier)
func check_tile():
	for ghost in get_tree().get_nodes_in_group('ghosts'):
		if ghost.position_tile_current == position_tile_current:
			get_tree().call_group('entities', 'respawn')

func respawn():
	if GameState.lives != 0:
		GameState.lives -= 1
	else:
		GameState.end_game()
	set_process(false)
	sprite.set_animation('Death')
	animation_timer.start()


func _on_animation_timer_timeout() -> void:
	sprite.set_animation('run')
	sprite.pause()	
	global_position = tile_map.map_to_local(Vector2(13, 27))
	additional_timer.start()

func _on_additional_timer_timeout() -> void:
	set_process(true)
