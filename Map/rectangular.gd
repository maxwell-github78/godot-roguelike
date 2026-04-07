class_name Rectangular
extends Room

	
func dig():
	var working = rect.grow(-1)
	tiles_to_carve = []
	for y in range(working.position.y, working.end.y + 1):
		for x in range(working.position.x, working.end.x + 1):
			var vector = Vector2i(x, y)
			tiles_to_carve.append(vector)

func walls():
	for x in range(rect.position.x, rect.end.x + 1):
		tiles_to_wall.append(Vector2i(x, rect.position.y))
	
	for y in range(rect.position.y + 1, rect.end.y):
		tiles_to_wall.append(Vector2i(rect.position.x, y))
		tiles_to_wall.append(Vector2i(rect.end.x, y))

	for x in range(rect.position.x, rect.end.x + 1):
		tiles_to_wall.append(Vector2i(x, rect.end.y))
	
	
func init_marks():
	var mark1 := Mark.new()
	var mark2 := Mark.new()
	var mark3 := Mark.new()
	var mark4 := Mark.new()
	mark1.direction = Vector2i(-1, 0)
	mark1.position = Vector2i(rect.position.x, rng.randi_range(rect.position.y + 1, rect.end.y - 1))
	mark2.direction = Vector2i(1, 0)
	mark2.position = Vector2i(rect.end.x, rng.randi_range(rect.position.y + 1, rect.end.y - 1))
	mark3.direction = Vector2i(0, -1)
	mark3.position = Vector2i(rng.randi_range(rect.position.x + 1, rect.end.x - 1), rect.position.y)
	mark4.direction = Vector2i(0, 1)
	mark4.position = Vector2i(rng.randi_range(rect.position.x + 1, rect.end.x - 1), rect.end.y)
	
	marks = [mark1, mark2, mark3, mark4]
	
	
