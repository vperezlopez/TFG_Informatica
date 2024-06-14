extends Object

class_name Utils

static func name_to_file_name(obj_name : String) -> String:
	return obj_name.to_lower().replace(" ", "_")

#static func name_to_path(folder_path : String, obj_name : String) -> String:
	#return obj_name.to_lower().replace(" ", "_")
