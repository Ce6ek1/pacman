extends Ghost

func target_on_chase_state():
	if position_tile_current.distance_to(pac_man.position_tile_current) <= 8:
		return position_scatter_corner
	return pac_man.position_tile_current

func target_on_spook_state() -> Vector2i:
	return position_scatter_corner + pac_man.current_direction * 4 + Vector2i(-3, -5)

func can_release_the_ghosts() -> bool:
	if GameState.collected_points >= 90:
		return true
	return false
