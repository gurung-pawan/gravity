class_name Body

const MINIMUM_MASS = 0.1
const MINIMUM_RADIUS = 0.1

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

func _init(
    _id: int,
    _mass: float = 1.0,
    _radius: float = 1.0,
    _position: Vector2 = Vector2.ZERO,
    _velocity: Vector2 = Vector2.ZERO,
    _type: BodyType = BodyType.SMALL_BODY
) -> void:

    self.id = _id
    self.mass = max(_mass, MINIMUM_MASS)
    self.radius = max(_radius, MINIMUM_RADIUS)
    self.position = _position
    self.velocity = _velocity
    self.type = _type

func update_motion(_position: Vector2 = self.position, _velocity: Vector2 = self.velocity, _acceleration: Vector2 = self.acceleration):
    self.position = _position
    self.velocity = _velocity
    self.acceleration = _acceleration