extends Object

class_name Utils

static func name_to_file_name(obj_name : String) -> String:
	return obj_name.to_lower().replace(" ", "_")

#static func name_to_path(folder_path : String, obj_name : String) -> String:
	#return obj_name.to_lower().replace(" ", "_")


static func random_city_name() -> String:
	var res
	
	#var pre_arr = [
		#'Villa',
		#'Pozos',
		#'Tabernas',
		#'Campos',
		#'Jarama',
		#'Pajares',
		#'Caudales',
		#'Fuente',
		#'Balcones',
		#'Alcázar',
		#'Venta',
		#'Casas'
	#]
	#
	#var mid = ' de'
	#
	#var suf_arr = [
		#'l Arzobispo',
		#'l Patriarca',
		#' la Reina',
		#'l Moro',
		#' la Sierra',
		#'l Duque',
		#' la Marquesa',
		#'l Rey',
		#' Dios',
		#' la Alegría',
		#'l Viajero',
		#' Piedrasgordas',
		#'l Herrero'
	#]
	#
	#res = pre_arr[(randi() % pre_arr.size()) - 1] + mid + suf_arr[(randi() % suf_arr.size())]
	
	var names = [
		'Villarona',
		'Ferrarca',
		'Yagado',
		'Teorramas',
		'Calopias',
		'Baldares',
		'Jocinio',
		'Verigoda',
		'Leosina',
		'Lunaremo',
		'Numira',
		'Salara',
		'Reginia',
		'Rea',
		'Allita',
		'Ruécamo',
		'Merensia',
		'Bearana',
		'Olofrana',
		'Urdago',
		#'Iplasia',
		'Anarema',
		'Diomado',
		'Damasia',
		'Telenia',
		'Tamador',
		'Hemeria'
	]
	res = names[(randi() % names.size()) - 1]
	
	return res
