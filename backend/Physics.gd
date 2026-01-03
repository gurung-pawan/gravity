class_name Physics

static var G = SimConfig.G

static func get_gravitational_bind_energy(body: Body) -> float:
    return G * (body.mass ** 2) / body.radius

static func get_kinetic_energy(body_1: Body, body_2: Body) -> float:
    var reduced_mass = (body_1.mass * body_2.mass) / (body_1.mass + body_2.mass)
    var relative_velocity_sqr = (body_1.velocity - body_2.velocity).length_squared()

    return 0.5 * reduced_mass * relative_velocity_sqr

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

    var new_velocity = body_1.velocity - body_2.velocity

    return {
        "mass": total_mass,
        "radius": new_radius,
        "position": new_position,
        "velocity": new_velocity,
    }