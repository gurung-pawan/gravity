class_name Gravity

# A small value to prevent division by zero error
static var eps = SimConfig.EPSILON
static var G = SimConfig.G

class GravityResult:
	var id: int
	var position: Vector2
	var velocity: Vector2
	var acceleration: Vector2

	func _init(_id: int, _position: Vector2, _velocity: Vector2, _acceleration: Vector2) -> void:
		self.id = _id
		self.position = _position
		self.velocity = _velocity
		self.acceleration = _acceleration

static func calculate(delta: float, bodies: Array[Body]) -> Array[GravityResult]:

	var results: Array[GravityResult] = []
	var size := bodies.size()

	for i in range(size):
		var body_1 = bodies[i]
		var acceleration = Vector2.ZERO

		for j in range(size):
			if i == j: continue
			var body_2 = bodies[j]
			var dir_dis = body_2.position - body_1.position
			var dis3 = max(eps, dir_dis.length() ** 3)
			acceleration += (G * body_2.mass * dir_dis) / dis3
		
		var position = body_1.position + (body_1.velocity * delta) + (0.5 * acceleration * (delta ** 2))
		var velocity = body_1.velocity + (0.5 * (body_1.acceleration + acceleration) * delta)
		results.append(GravityResult.new(body_1.id, position, velocity, acceleration))

	return results
