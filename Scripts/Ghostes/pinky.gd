extends Ghost

func target_on_chase_state() -> Vector2i:
	return pac_man.position_tile_current + pac_man.current_direction * 4

func target_on_spook_state() -> Vector2i:
	return pac_man.position_tile_current + pac_man.current_direction * 5 + Vector2i(2, -3)

func can_release_the_ghosts() -> bool:
	if GameState.collected_points >= 30:
		return true
	return false
