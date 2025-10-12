extends Ghost

func target_on_chase_state():
	if position_tile_current.distance_to(pac_man.position_tile_current) <= 8:
		return position_scatter_corner
	return pac_man.position_tile_current
