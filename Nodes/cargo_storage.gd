extends Object

class_name CargoStorage

const cargo_catalog = preload(Constants.CARGO_CATALOG_PATH) as CargoCatalog

var _capacity : int

var space : int

var _cargo_dict : Dictionary

var _whitelist : Array[int]
var _blacklist : Array[int]

func init(cap : int, whitelist : Array[Cargo] = [], blacklist : Array[Cargo] = []):
	self._capacity = cap
	self.space = self._capacity
	set_whitelist(whitelist)
	set_blacklist(blacklist)

func get_cargo() -> Array:
	var res = []
	for cargo_id in _cargo_dict:
		#res.append(cargo)
		res.append(cargo_catalog.get_cargo(cargo_id))
	return res
	

func get_quantity(cargo : Cargo) -> int:
	
	if _cargo_dict.has(cargo.id):
		return _cargo_dict[cargo.id]
	else:
		return 0

## Returns tuples for every cargo item in the Cargo Storage, along with its quantity
func get_inventory() -> Array:
	var res = []
	for cargo_id in _cargo_dict:
		res.append([cargo_catalog.get_cargo(cargo_id), _cargo_dict[cargo_id]])
	return res

func get_free_space() -> int:
	return space

func add_cargo(cargo : Cargo, quantity : int = Constants.MAX_INT) -> int:
	# Checks if it can accept the cargo
	if !_blacklist.has(cargo.id):
		if _whitelist.is_empty() or _whitelist.has(cargo.id):
			if space:
				# Accepts as much as it can
				quantity = clamp(quantity, quantity, space)
				# If cargo exists, adds more
				if _cargo_dict.has(cargo.id):
					_cargo_dict[cargo.id] += quantity
				# If it doesn't, creates the entry
				else:
					_cargo_dict[cargo.id] = quantity
				# Calculates space left
				space -= quantity
				return quantity
	return 0

func remove_cargo(cargo : Cargo, quantity : int = Constants.MAX_INT) -> int:
	if _cargo_dict.has(cargo.id):
		quantity = clamp(quantity, 0, _cargo_dict[cargo.id])
		_cargo_dict[cargo.id] -= quantity
		if _cargo_dict[cargo.id] == 0:
			_cargo_dict.erase(cargo.id)
		space += quantity
		return quantity
	else:
		return 0
	

func flush():
	var res : Array = []
	for cargo_id in _cargo_dict:
		var cargo : Cargo = cargo_catalog.get_cargo(cargo_id)
		var quantity : int = remove_cargo(cargo)
		res.append([cargo, quantity])
	return res
		

func add_whitelisted(whitelist : Array[Cargo]):
	if !whitelist.is_empty():
		for cargo in whitelist:
			if !_whitelist.has(cargo.id):
				_whitelist.append(cargo.id)
				
func add_blacklisted(blacklist : Array[Cargo]):
	if !blacklist.is_empty():
		for cargo in blacklist:
			if !_blacklist.has(cargo.id):
				_blacklist.append(cargo.id)
				
func set_whitelist(whitelist : Array[Cargo] = []):
	_whitelist = []
	add_whitelisted(whitelist)

func set_blacklist(blacklist : Array[Cargo] = []):
	_blacklist = []
	add_blacklisted(blacklist)
