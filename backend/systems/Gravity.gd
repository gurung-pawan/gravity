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

static func compute_gravitational_acceleration(bodies: Array[Body], positions = null) -> Array[Vector2]:
	var accelerations: Array[Vector2] = []
	
	for i in range(bodies.size()):
		var acceleration := Vector2.ZERO
		var body_1 = bodies[i]

		for j in range(bodies.size()):
			if i == j: continue

			var body_2 = bodies[j]

			var dir_dis = body_2.position - body_1.position if positions == null else positions[j] - positions[i]
			var dis3 = max(eps, dir_dis.length() ** 3)
			acceleration += (G * body_2.mass * dir_dis) / dis3
		
		accelerations.append(acceleration)

	return accelerations

static func calculate(delta: float, bodies: Array[Body]) -> Array[GravityResult]:

	var results: Array[GravityResult] = []

	var predicted_positions: Array[Vector2] = []

	# prediction position
	for body in bodies:
		var new_pos = body.position + (body.velocity * delta) + (0.5 * body.acceleration * (delta ** 2));
		predicted_positions.append(new_pos)
	
	# prediction acceleration
	var predicted_acceleration: Array[Vector2] = compute_gravitational_acceleration(bodies, predicted_positions)

	# update velocity using average of the accelerations
	var size: int = bodies.size()
	for i in range(size):
		var body = bodies[i]
		var new_velocity = body.velocity + (0.5 * (body.acceleration + predicted_acceleration[i]) * delta)
		
		results.append(GravityResult.new(
			body.id,
			predicted_positions[i],
			new_velocity,
			predicted_acceleration[i]
		))

	return results
