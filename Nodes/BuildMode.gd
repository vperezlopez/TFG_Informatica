extends Object

#class_name BuildMode

const NONE = 0
const DEMOLISH = 8
const DEMOLISH_ROAD = 9

class BUILDING:
	const NONE = 100
	const FACTORY = 101
	const WAREHOUSE = 102
	const DEPOT_ROAD = 103
	const DEPOT_RAIL = 104

class PATH:
	const NONE = 200
	const ROAD = 201
	const RAILWAY = 202

#const BUILDINGS = [BUILDING.FACTORY, BUILDING.WAREHOUSE, BUILDING.DEPOT_ROAD, BUILDING.DEPOT_RAIL]
#const PATHS = [PATH.ROAD, PATH.RAILWAY]

const MODES = {
	NONE: "NONE",
	DEMOLISH: "DEMOLISH",
	DEMOLISH_ROAD: "DEMOLISH_ROAD",
	BUILDING.FACTORY: "BUILDING",
	BUILDING.WAREHOUSE: "BUILDING",
	BUILDING.DEPOT_ROAD: "BUILDING",
	BUILDING.DEPOT_RAIL: "BUILDING",
	PATH.NONE: "PATH",
	PATH.ROAD: "PATH",
	PATH.RAILWAY: "PATH"
}