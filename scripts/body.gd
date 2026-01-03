extends Node2D

var id: int
var radius: float

func _draw() -> void:
    draw_circle(Vector2.ZERO, radius, Color.BLUE)

func init(_id: int, _radius: float, _position: Vector2):
    self.id = _id
    self.radius = _radius
    self.position = _position