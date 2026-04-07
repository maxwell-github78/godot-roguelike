class_name Cave
extends Room
	
func dig():
	var digger := rect.get_center()
	var bounds := rect.grow(-1)
	tiles_to_carve = [digger]
	var attempts: int = 0
	var directions: Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	while attempts < 600 and len(tiles_to_carve) < 0.35 * bounds.get_area():
		var index := rng.randi_range(0, len(directions)-1)
		var direction = directions[index]
		if bounds.has_point(digger + direction):
			digger += direction
			if digger not in tiles_to_carve:
				tiles_to_carve.append(digger)
		attempts += 1	
		
func walls():
	pass

func init_marks():
	var mark1 := Mark.new()
	mark1.direction = Vector2i(-1, 0)
	var mark2 := Mark.new()
	mark2.direction = Vector2i(1, 0)
	var mark3 := Mark.new()
	mark3.direction = Vector2i(0, -1)
	var mark4 := Mark.new()
	mark4.direction = Vector2i(0, 1)
	var leftmost := rect.get_center() 
	var rightmost := rect.get_center()
	var topmost := rect.get_center()
	var bottommost := rect.get_center()
	for vector in tiles_to_carve:
		if vector.x > rightmost.x:
			rightmost = vector
		if vector.x < leftmost.x:
			leftmost = vector
		if vector.y > topmost.y:
			topmost = vector
		if vector.y < bottommost.y:
			bottommost = vector
	mark1.position = leftmost + mark1.direction
	mark2.position = rightmost + mark2.direction
	mark3.position = bottommost + mark3.direction
	mark4.position = topmost + mark4.direction
	marks = [mark1, mark2, mark3, mark4]
			
