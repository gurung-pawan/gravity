class_name Body

var minimum_mass = 0.5
var minimum_radius = 0.5

enum BodyType {
	SMALL_BODY = 0,
	PLANET,
	STAR,
	BLACK_HOLE
}

var id: int
var mass: float
var radius: float
var position: Vector2
var velocity: Vector2
var acceleration: Vector2 = Vector2.ZERO
var type: BodyType

func find_type():
	var density = self.mass / (PI * self.radius ** 2)
	if density < SimConfig.PLANET_COMPACTNESS_THRESHOLD:
		return BodyType.SMALL_BODY
	elif density < SimConfig.STAR_COMPACTNESS_THRESHOLD:
		return BodyType.PLANET
	elif density < SimConfig.BLACK_HOLE_COMPACTNESS_THRESHOLD:
		return BodyType.STAR
	else:
		return BodyType.BLACK_HOLE

func _init(
	_id: int,
	_mass: float = 1.0,
	_radius: float = 1.0,
	_position: Vector2 = Vector2.ZERO,
	_velocity: Vector2 = Vector2.ZERO,
	_type = null
) -> void:

	self.id = _id
	self.mass = max(_mass, minimum_mass)
	self.radius = max(_radius, minimum_radius)
	self.position = _position
	self.velocity = _velocity
	self.type = find_type() if _type == null else _type

func update_motion(_position: Vector2 = self.position, _velocity: Vector2 = self.velocity, _acceleration: Vector2 = self.acceleration):
	self.position = _position
	self.velocity = _velocity
	self.acceleration = _acceleration

func update_motion_naturally(delta: float):
	# When force (incl. gravitational force) is not applied to a body, it doesn't have any acceleration
	# Inertia
	self.position += (delta * self.velocity)
