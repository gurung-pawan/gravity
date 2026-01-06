extends Node2D

var BodyScene = preload("res://scenes/body.tscn")

@onready var bodies_node: Node = $BodiesNode

var time_scale = SimConfig.TIME_SCALE

var bodies: Dictionary[int, Node2D] = {}

func add_body(body: Body):
	var bodyNode = BodyScene.instantiate()
	bodyNode.init(body.id, body.radius, body.position)
	self.bodies[body.id] = bodyNode
	bodies_node.add_child(bodyNode)

func remove_body_by_id(_id: int):
	for body_node in self.bodies_node.get_children():
		if body_node.id == _id:
			self.bodies_node.remove_child(body_node)
			break
	self.bodies.erase(_id)

func _ready() -> void:
	var id1 = Sim.make_body(100, 20, Vector2(0, 0), Vector2(130, 0), Body.BodyType.SMALL_BODY)
	var id2 = Sim.make_body(100, 20, Vector2(100, 0), Vector2(0, 0), Body.BodyType.SMALL_BODY)
	var id3 = Sim.make_body(200, 20, Vector2(400, 0), Vector2(0, 0), Body.BodyType.SMALL_BODY)
	add_body(Sim.get_body_by_id(id1))
	add_body(Sim.get_body_by_id(id2))
	add_body(Sim.get_body_by_id(id3))

func _physics_process(delta: float) -> void:
	Sim.update_step(self.time_scale * delta)
	for id in self.bodies:
		if id not in Sim.bodies:
			remove_body_by_id(id)
			continue
		self.bodies[id].position = Sim.bodies[id].position

	for id in Sim.bodies:
		if id not in self.bodies:
			add_body(Sim.get_body_by_id(id))
			
