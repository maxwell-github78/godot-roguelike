class_name Round
extends Room

#REDO:
#Function that generates the full shape (and then caches it!)
#WHY DIDN*T YOU GENERATE THE FULL SHAPE ARGH:::DO THAT
#Then you can forget the edge columns and the top and bottom tiles of the innner columns
#Marks can be calculated using this method as well

var rasterisation_cache: Array

func shift(amount: Vector2i):
	var shifted_tiles_to_carve: Array[Vector2i] = []
	var shifted_tiles_to_wall: Array[Vector2i] = []
	rasterise(true)
	for vector in tiles_to_carve:
		shifted_tiles_to_carve.append(vector + amount)
	for vector in tiles_to_wall:
		shifted_tiles_to_wall.append(vector + amount)
	tiles_to_carve = shifted_tiles_to_carve
	tiles_to_wall = shifted_tiles_to_wall

func rasterise(override: bool) -> Array:
	if rasterisation_cache and not override:
		return rasterisation_cache

	var edge_rasterisation: Array[Vector2i] = []
	var centre := rect.get_center()
	var a: int = floor(rect.size.x / 2.0) #radius x-axis
	var b: int = floor(rect.size.y / 2.0) #radius y-axis

	var a2: int = a * a
	var b2: int = b * b
	var fa2: int = 4 * a2
	var fb2: int = 4 * b2
	
	var x: int = 0
	var y: int = b
	var sigma: int = 2 * b2 + a2 * (1 - 2 * b)
	while b2*x <= a2*y:
		edge_rasterisation.append(Vector2i(centre.x + x, centre.y + y))
		edge_rasterisation.append(Vector2i(centre.x - x, centre.y + y))
		edge_rasterisation.append(Vector2i(centre.x + x, centre.y - y))
		edge_rasterisation.append(Vector2i(centre.x - x, centre.y - y))
		if sigma >= 0:
			sigma += fa2 * (1 - y)
			y -= 1
		sigma += b2 * (4 * x + 6)
		x += 1
	
	x = a
	y = 0
	sigma = 2 * a2 + b2 * (1 - 2 * a)
	while a2*y <= b2*x:
		edge_rasterisation.append(Vector2i(centre.x + x, centre.y + y))
		edge_rasterisation.append(Vector2i(centre.x - x, centre.y + y))
		edge_rasterisation.append(Vector2i(centre.x + x, centre.y - y))
		edge_rasterisation.append(Vector2i(centre.x - x, centre.y - y))
		if sigma >= 0:
			sigma += fb2 * (1 - x)
			x -= 1
		sigma += a2 * (4 * y + 6)
		y += 1
		
	var edge_columns := sort_into_columns(edge_rasterisation)
	var columns: Array = []
	for edge in edge_columns:
		var column: Array[Vector2i] = []
		var fixed_x: int = edge[0].x
		for variable_y in range(edge[0].y, edge[-1].y):
			column.append(Vector2i(fixed_x, variable_y))
		columns.append(column)
	rasterisation_cache = columns
	#print(rasterisation_cache)
	return rasterisation_cache	
	
	
func sort_into_columns(input: Array[Vector2i]) -> Array:
	var out := []
	
	var min_x: int = input[0].x
	var max_x: int = input[0].x
	for vector in input:
		min_x = min(min_x, vector.x)
		max_x = max(max_x, vector.x)
	
	for row in range(max_x - min_x + 1):
		out.append(Array())
	#print(out)
	
	for vector in input:
		out[vector.x - min_x].append(vector)
	
	for column in out:
		column.sort_custom(vector_y)
	
	return out
	
func vector_y(a: Vector2i, b: Vector2i) -> bool:
	if a.y < b.y:
		return true
	return false
	
func dig() -> void:
	for column in rasterise(false).slice(1, -1):
		for vector in column.slice(1, -1):
			tiles_to_carve.append(vector)
		
func walls() -> void:
	var columns := rasterise(false)
	tiles_to_wall += columns[0] + columns[-1]
	for column in columns.slice(1, -1):
		tiles_to_wall.append(column[0])
		tiles_to_wall.append(column[-1])
	
	var change: int
	for index in range(0, (columns.size() - 1) / 2 ):
		change = columns[index][0].y - columns[index + 1][0].y 
		for y_add in range(1, change + 1):
			var backwards_index: int = -1 - index
			tiles_to_wall.append(Vector2i(columns[index][0].x, columns[index][0].y - y_add))
			tiles_to_wall.append(Vector2i(columns[index][-1].x, columns[index][-1].y + y_add))
			tiles_to_wall.append(Vector2i(columns[backwards_index][0].x, columns[backwards_index][0].y - y_add))
			tiles_to_wall.append(Vector2i(columns[backwards_index][-1].x, columns[backwards_index][-1].y + y_add))
	
func init_marks() -> void:
	var columns := rasterise(false)
	
	var mark1 := Mark.new()
	mark1.direction = Vector2i(-1, 0)
	var left_column: Array = columns[0]
	mark1.position = left_column[rng.randi_range(0, left_column.size() - 1)]
	
	var mark2 := Mark.new()
	mark2.direction = Vector2i(1, 0)
	var right_column: Array = columns[-1]
	mark2.position = right_column[rng.randi_range(0, right_column.size() - 1)]
	
	var y_max: int = 0
	var first: int = 0
	var last: int = 0
	var height: int
	for index in range(0, columns.size()-1): 
		height = columns[index][-1].y 
		if height > y_max:
			y_max = height
			first = index 
		if height == y_max - 1:
			last = index
	var middle_columns := columns.slice(first, last-1)
	
	var mark3 := Mark.new()
	mark3.direction = Vector2i(0, -1)
	mark3.position = middle_columns[rng.randi_range(0, middle_columns.size() - 1)][0]
	
	var mark4 := Mark.new()
	mark4.direction = Vector2i(0, 1)
	mark4.position = middle_columns[rng.randi_range(0, middle_columns.size() - 1)][-1]
	
	marks = [mark1, mark2, mark3, mark4]
	
	
	
	
	
	
