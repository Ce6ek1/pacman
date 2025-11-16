extends Ghost
@onready var blinky: Node2D = $"/root/Main/Map/Blinky"

func target_on_chase_state() -> Vector2i:
	var tile_at_front = pac_man.position_tile_current + (pac_man.current_direction * 2)
	var blinky_ray = (tile_at_front - blinky.position_tile_current)
	return (tile_at_front + blinky_ray*2)

func target_on_spook_state() -> Vector2i:
	return pac_man.position_tile_current + pac_man.current_direction * 4 + Vector2i(1, -4)

func can_release_the_ghosts() -> bool:
	if GameState.collected_points >= 60:
		return true
	return false
