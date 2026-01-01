class_name Sim

var bodies: Dictionary[int, Body] = {}
var body_count: int = 0

# ONLY ENTRY TO MAKING BODY
func make_body(mass: float = 1.0, radius: float = 1.0, position: Vector2 = Vector2.ZERO, velocity: Vector2 = Vector2.ZERO, type: Body.BodyType = Body.BodyType.SMALL_BODY) -> int:

    var body = Body.new(self.body_count, mass, radius, position, velocity, type)
    bodies[body.id] = body
    self.body_count += 1
    return body.id

func get_body_by_id(_id: int) -> Body:
    return self.bodies.get(_id, null)

func remove_body_by_id(_id: int) -> bool:
    return self.bodies.erase(_id)

func update_gravity(delta: float, bodies_array: Array[Body]):
    var gravity_data: Array[Gravity.GravityResult] = Gravity.calculate(delta, bodies_array)

    for data in gravity_data:
        self.bodies[data.id].update_motion(data.position, data.velocity, data.acceleration)

func update_collision(bodies_array: Array[Body]):
    var collision_data: Array[Collision.CollisionResult] = Collision.check(bodies_array)
    
    for data in collision_data:
        if data.type == Collision.CollisionType.MERGE:
            pass
        else:
            pass

func update_step(delta: float):
    var bodies_array: Array[Body] = self.bodies.values()
    self.update_gravity(delta, bodies_array)
    self.update_collision(bodies_array)