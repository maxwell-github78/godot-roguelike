class_name Files
extends Object

static func read_definitions(path_string: String):
	var dir := DirAccess.open(path_string)
	var definitions: Dictionary = {}
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var file_path_string: String
		var key: String
		while file_name != "":
			file_path_string = path_string + "/" + file_name
			key = file_name.replace(".tres", "")
			definitions[key] = load(file_path_string)
			file_name = dir.get_next()
		return definitions 
	else:
		print("An error occurred when trying to access the path to definitions")
		return false 
