extends Ghost

func target_on_chase_state() -> Vector2i:
	return tile_map.local_to_map(pac_man.global_position)

func target_on_spook_state() -> Vector2i:
	return pac_man.position_tile_current + pac_man.current_direction * 2 + Vector2i(4, 1)

func can_release_the_ghosts():
	return true
