extends TileMapLayer
@onready var pacman: Node2D = $'/root/Main/Map/PacMan'




func _ready():
	add_to_group('tilemap')

func restart_map():
	for ghost in get_tree().get_nodes_in_group('ghosts'):
		ghost.global_position = ghost.position_start_tile

func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		print(local_to_map(get_global_mouse_position()))
