extends Node2D

var planet_compactness_threshold = SimConfig.PLANET_COMPACTNESS_THRESHOLD
var star_compactness_threshold = SimConfig.STAR_COMPACTNESS_THRESHOLD
var black_hole_compactness_threshold = SimConfig.BLACK_HOLE_COMPACTNESS_THRESHOLD

var id: int
var mass: float
var radius: float
var color: Color
var type: Body.BodyType

func attach_shader():
    var mat = ShaderMaterial.new()
    mat.shader = preload("res://frontend/shaders/star_shader.gdshader")
    mat.set_shader_parameter("glow_color", self.color)
    mat.set_shader_parameter("glow_intensity", self.radius * 0.5)
    self.material = mat

func get_random_planet_color() -> Color:
    var random = randf()
    if random < 0.34:
        return Color8(112, 151, 209)
    elif random < 0.67:
        return Color8(132, 89, 43)
    else:
        return Color8(193, 206, 156)

func get_star_color() -> Color:
    var density = self.mass / (PI * self.radius ** 2)
    var density_partition = (black_hole_compactness_threshold + star_compactness_threshold) / 3
    if density < density_partition:
        return Color8(191, 11, 0)
    elif density < (2 * density_partition):
        return Color8(238, 255, 84)
    else:
        return Color8(48, 90, 255)

func find_color() -> void:
    if type == Body.BodyType.SMALL_BODY:
        self.color = Color8(204, 204, 207)
    elif type == Body.BodyType.PLANET:
        self.color = self.get_random_planet_color()
    elif type == Body.BodyType.STAR:
        self.color = self.get_star_color()
    else:
        self.color = Color.BLACK


func _draw() -> void:
    draw_circle(Vector2.ZERO, radius, self.color)
    if self.type == Body.BodyType.BLACK_HOLE:
        var ring_color = Color(0.9, 0.15, 0.0, radius)
        draw_arc(Vector2.ZERO, self.radius, 0.0, TAU, 64, ring_color, 0.5)

func init(_id: int, _mass: float, _radius: float, _position: Vector2, _type: Body.BodyType):
    self.id = _id
    self.mass = _mass
    self.radius = _radius
    self.position = _position
    self.type = _type
    self.find_color()
    if self.type == Body.BodyType.STAR:
        attach_shader()