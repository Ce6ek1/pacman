extends Ghost

func target_on_chase_state() -> Vector2i:
	return tile_map.local_to_map(pac_man.global_position)
