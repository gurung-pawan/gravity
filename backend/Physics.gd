class_name Physics

static var G = SimConfig.G
static var min_frag = SimConfig.MINIMUM_FRAGMENTATION
static var max_frag = SimConfig.MAXIMUM_FRAGMENTATION
static var eps = SimConfig.EPSILON
static var minimum_mass = SimConfig.MINIMUM_MASS
static var minimum_radius = SimConfig.MINIMUM_RADIUS
static var bh_density = SimConfig.BLACK_HOLE_COMPACTNESS_THRESHOLD

static func rotate_vector(v: Vector2, t: float) -> Vector2:
	return Vector2(
		v.x * cos(t) - v.y * sin(t),
		v.x * sin(t) + v.y * cos(t)
	)

static func get_random_sum_array(sum: float, length: int, minimum: float) -> Array:

	var remaining = sum - length * minimum
	var nums = []
	var total = 0.0

	for i in length:
		var v = randf()
		nums.append(v)
		total += v

	var result = []
	var running_sum = 0.0

	for i in length - 1:
		var val = minimum + (nums[i] / total) * remaining
		result.append(val)
		running_sum += val

	result.append(sum - running_sum)

	return result

static func get_momentum(body: Body) -> Vector2:
	return body.mass * body.velocity

static func get_gravitational_bind_energy(body: Body) -> float:
	return G * (body.mass ** 2) / body.radius

static func get_kinetic_energy(body_1: Body, body_2: Body) -> float:
	var reduced_mass = (body_1.mass * body_2.mass) / (body_1.mass + body_2.mass)
	var relative_velocity_sqr = (body_1.velocity - body_2.velocity).length_squared()

	return 0.5 * reduced_mass * relative_velocity_sqr

static func fragment_bodies(body_1: Body, body_2: Body):
	var results = []

	var relative_velocity = body_1.velocity - body_2.velocity

	var total_radius = sqrt(body_1.radius ** 2 + body_2.radius ** 2) 
	var total_mass = body_1.mass + body_2.mass
	var density = total_mass / (PI * (total_radius ** 2))

	if total_mass < minimum_mass or total_radius < minimum_radius:
		return results

	var amount_of_fragments = randi_range(min_frag, max_frag)

	var mass_allocation = get_random_sum_array(total_mass, amount_of_fragments, minimum_mass)

	var collision_point = (body_1.position + body_2.position) / 2.0

	for i in amount_of_fragments:
		var theta = randf_range(-PI, PI)
		var velocity = rotate_vector(relative_velocity, theta) * randf_range(eps, 0.5)

		var r = pow(mass_allocation[i] / (PI * density), 0.5)
		var offset = Vector2(r * cos(theta), r * sin(theta))
		var position = collision_point + (r * offset)

		results.append({
			"mass": mass_allocation[i],
			"radius": r,
			"position": position,
			"velocity": velocity
		})

	return results

static func merge_bodies(body_1: Body, body_2: Body):
	var total_mass = body_1.mass + body_2.mass
	var new_radius = sqrt(body_1.radius ** 2 + body_2.radius ** 2)
	var new_position: Vector2

	var is_body_1_black_hole = body_1.type == Body.BodyType.BLACK_HOLE
	var is_body_2_black_hole = body_2.type == Body.BodyType.BLACK_HOLE

	if is_body_1_black_hole == is_body_2_black_hole:
		if body_1.mass * body_1.radius > body_2.mass * body_2.radius:
			new_position = body_1.position
		else:
			new_position = body_2.position
	else:
		new_position = body_1.position if is_body_1_black_hole else body_2.position
		new_radius = log(total_mass / (PI * bh_density))


	var new_velocity = (get_momentum(body_1) + get_momentum(body_2)) / (body_1.mass + body_2.mass)

	return {
		"mass": total_mass,
		"radius": new_radius,
		"position": new_position,
		"velocity": new_velocity,
	}
