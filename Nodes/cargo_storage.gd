extends Object

class_name CargoStorage

var _capacity : int

var space : int

var _cargo_dict : Dictionary

var _whitelist : Array[Cargo]
var _blacklist : Array[Cargo]

func init(cap : int, whitelist : Array[Cargo] = [], blacklist : Array[Cargo] = []):
	self._capacity = cap
	self.space = self._capacity
	set_whitelist(whitelist)
	set_blacklist(blacklist)

func get_cargo() -> Array:
	var res = []
	for cargo in _cargo_dict:
		res.append(cargo)
	return res
	

func get_quantity(cargo : Cargo) -> int:
	if _cargo_dict.has(cargo):
		return _cargo_dict[cargo]
	else:
		return 0

## Returns tuples for every cargo item in the Cargo Storage, along with its quantity
func get_inventory() -> Array:
	var res = []
	for cargo in _cargo_dict:
		res.append([cargo, _cargo_dict[cargo]])
	return res

func add_cargo(cargo : Cargo, quantity : int = Constants.MAX_INT) -> int:
	# Checks if it can accept the cargo
	if !_blacklist.has(cargo):
		if _whitelist.is_empty() or _whitelist.has(cargo):
			if space:
				# Accepts as much as it can
				quantity = clamp(quantity, quantity, space)
				# If cargo exists, adds more
				if _cargo_dict.has(cargo):
					_cargo_dict[cargo] += quantity
				# If it doesn't, creates the entry
				else:
					_cargo_dict[cargo] = quantity
				# Calculates space left
				space -= quantity
				return quantity
	return 0

func remove_cargo(cargo : Cargo, quantity : int = Constants.MAX_INT) -> int:
	if _cargo_dict.has(cargo):
		quantity = clamp(quantity, 0, _cargo_dict[cargo])
		_cargo_dict[cargo] -= quantity
		if _cargo_dict[cargo] == 0:
			_cargo_dict.erase(cargo)
		space += quantity
		return quantity
	else:
		return 0
	
func add_whitelisted(whitelist : Array[Cargo]):
	if !whitelist.is_empty():
		for cargo in whitelist:
			if !_whitelist.has(cargo):
				_whitelist.append(cargo)
				
func add_blacklisted(blacklist : Array[Cargo]):
	if !blacklist.is_empty():
		for cargo in blacklist:
			if !_blacklist.has(cargo):
				_blacklist.append(cargo)
				
func set_whitelist(whitelist : Array[Cargo] = []):
	_whitelist = []
	add_whitelisted(whitelist)

func set_blacklist(blacklist : Array[Cargo] = []):
	_blacklist = []
	add_blacklisted(blacklist)
