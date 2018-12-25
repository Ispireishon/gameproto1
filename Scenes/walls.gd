extends TileMap

func _ready():
	draw_tile_line('0_c0_1_l', Vector2(1, 0), ['0_1_m'], {'0_c0_1_m':1, '0_c1_1_m':1})
	draw_tile_line('0_c0_1_r', Vector2(-1, 0), ['0_1_m'], {'0_c0_1_m':1, '0_c1_1_m':1})
	
	draw_tile_line('0_c1_1_l', Vector2(1, 0), ['0_1_m'], {'0_c0_1_m':1, '0_c1_1_m':1})
	draw_tile_line('0_c1_1_r', Vector2(-1, 0), ['0_1_m'], {'0_c0_1_m':1, '0_c1_1_m':1})
	
	draw_tile_line('0_c2_1_0_l', Vector2(1, 0), ['0_1_m'], {'0_c2_1_0_m':1})
	draw_tile_line('0_c2_1_0_r', Vector2(-1, 0), ['0_1_m'], {'0_c2_1_0_m':1})
	draw_tile_line('0_c2_1_1_l', Vector2(1, 0), ['0_1_m'], {'0_c2_1_1_m':1})
	draw_tile_line('0_c2_1_1_r', Vector2(-1, 0), ['0_1_m'], {'0_c2_1_1_m':1})
	draw_tile_line('0_c2_1_2_l', Vector2(1, 0), ['0_1_m'], {'0_c2_1_2_m':1})
	draw_tile_line('0_c2_1_2_r', Vector2(-1, 0), ['0_1_m'], {'0_c2_1_2_m':1})

func draw_tile_line(start_tile_name, direction, allow_change, variants):
	
	for i in range(len(allow_change)):
		allow_change[i] = tile_set.find_tile_by_name(allow_change[i])
	
	var variants_ids = {}
	for i in variants:
		variants_ids[tile_set.find_tile_by_name(i)] = variants[i]
	
	var start_tile_id = tile_set.find_tile_by_name(start_tile_name)
	
	for start_cell in get_used_cells_by_id(start_tile_id):
		var pos = start_cell + direction
		while get_cellv(pos) in allow_change:
			set_cellv(pos, get_random_weighted_key(variants_ids))
			pos += direction

func get_random_weighted_key(dict):
	var s = 0
	for i in dict:
		s += dict[i]
	var q = randi() % s
	for i in dict:
		if q < dict[i]:
			return i
		q -= dict[i]
