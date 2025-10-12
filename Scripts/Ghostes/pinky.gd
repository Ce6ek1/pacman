extends Ghost

func target_on_chase_state() -> Vector2i:
	return pac_man.position_tile_current + pac_man.current_direction * 4
