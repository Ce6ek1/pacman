extends Ghost
@onready var blinky: Node2D = $"/root/Main/Map/Blinky"

func target_on_chase_state() -> Vector2i:
	var tile_at_front = pac_man.position_tile_current + (pac_man.current_direction * 2)
	var blinky_ray = (tile_at_front - blinky.position_tile_current)
	return (tile_at_front + blinky_ray*2)
