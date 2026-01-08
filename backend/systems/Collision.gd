class_name Collision

static var planet_threshold = SimConfig.PLANET_COMPACTNESS_THRESHOLD
static var star_threshold = SimConfig.STAR_COMPACTNESS_THRESHOLD
static var black_hole_threshold = SimConfig.BLACK_HOLE_COMPACTNESS_THRESHOLD

static var eps = SimConfig.EPSILON
static var Q = SimConfig.MERGE_CONSTANT
static var G = SimConfig.G
static var min_mass = SimConfig.MINIMUM_MASS
static var min_radius = SimConfig.MINIMUM_RADIUS

enum CollisionType {
	MERGE = 0,
	FRAGMENT
}

class CollisionResult:
	var ids := []
	var type: CollisionType
	var form: Body.BodyType

	func _init(_ids: Array, _type: CollisionType):
		self.ids = _ids
		self.type = _type

static func detect_type(body_1: Body, body_2: Body) -> CollisionType:

	if body_1.radius < min_radius or body_2.radius < min_radius or body_1.mass < min_mass or body_2.mass < min_mass:
		return CollisionType.MERGE

	var kinetic_energy = Physics.get_kinetic_energy(body_1, body_2)
	var gbe_1 = Physics.get_gravitational_bind_energy(body_1)
	var gbe_2 = Physics.get_gravitational_bind_energy(body_2)

	var fragments_1: bool = kinetic_energy > gbe_1
	var fragments_2: bool = kinetic_energy > gbe_2

	if fragments_1 and fragments_2:
		return CollisionType.FRAGMENT
	return CollisionType.MERGE

static func check(bodies: Array[Body]) -> Array[CollisionResult]:
	var results: Array[CollisionResult] = []
	var size = bodies.size()
	
	for i in range(size):
		var body_1 = bodies[i]
		for j in range(i + 1, size):

			var body_2 = bodies[j]
			var dir_dis = body_1.position - body_2.position
			var distance = dir_dis.length()
			var sum_of_radius = body_1.radius + body_2.radius

			if distance < sum_of_radius:
				results.append(CollisionResult.new(
					[body_1.id, body_2.id],
					detect_type(body_1, body_2)
				))

	return results