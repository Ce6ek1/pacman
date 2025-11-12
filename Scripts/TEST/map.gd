extends TileMapLayer
@onready var pacman: Node2D = $'/root/Main/Map/PacMan'




func _ready():
	add_to_group('tilemap')

func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		print(local_to_map(get_global_mouse_position()))
