class_name Sim

static var bodies: Dictionary[int, Body] = {}
static var body_count: int = 0
static var TIME_SCALE = SimConfig.TIME_SCALE

# ONLY ENTRY TO MAKING BODY
static func make_body(mass: float = 1.0, radius: float = 1.0, position: Vector2 = Vector2.ZERO, velocity: Vector2 = Vector2.ZERO, type: Body.BodyType = Body.BodyType.SMALL_BODY) -> int:

    var body = Body.new(body_count, mass, radius, position, velocity, type)
    bodies[body.id] = body
    body_count += 1
    return body.id

static func get_body_by_id(_id: int) -> Body:
    return bodies.get(_id, null)

static func remove_body_by_id(_id: int) -> bool:
    return bodies.erase(_id)

static func update_gravity(delta: float, bodies_array: Array[Body]):
    var gravity_data: Array[Gravity.GravityResult] = Gravity.calculate(delta, bodies_array)

    for data in gravity_data:
        bodies[data.id].update_motion(data.position, data.velocity, data.acceleration)

static func update_collision(bodies_array: Array[Body]):
    var collision_data: Array[Collision.CollisionResult] = Collision.check(bodies_array)
    var removed_id  = {}
    
    for data in collision_data:
        if data.ids[0] in removed_id or data.ids[1] in removed_id:
            continue

        var body_1 = get_body_by_id(data.ids[0])
        var body_2 = get_body_by_id(data.ids[1])
        if data.type == Collision.CollisionType.MERGE:
            var new_body_data = Physics.merge_bodies(body_1, body_2)
            make_body(
                new_body_data["mass"],
                new_body_data["radius"],
                new_body_data["position"],
                new_body_data["velocity"],
                data.form
            )
        else:
            var all_bodies_data = Physics.fragment_bodies(body_1, body_2)
            for body_data in all_bodies_data:
                make_body(
                    body_data["mass"],
                    body_data["radius"],
                    body_data["position"],
                    body_data["velocity"],
                    data.form
                )
        remove_body_by_id(data.ids[0])
        remove_body_by_id(data.ids[1])
        removed_id[data.ids[0]] = true
        removed_id[data.ids[1]] = true

static func update_step(delta: float):
    var bodies_array: Array[Body] = bodies.values()
    if bodies_array.size() >= 2:
        update_gravity(delta, bodies_array)
        update_collision(bodies_array)
    else:
        for x in bodies_array:
            x.update_motion_naturally(TIME_SCALE * delta)