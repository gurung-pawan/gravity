extends Node2D

var BodyScene = preload("res://scenes/body.tscn")

@onready var bodies_node: Node = $BodiesNode

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
	var id1 = Sim.make_body(10, 10, Vector2(0, 0), Vector2(10, 10), Body.BodyType.SMALL_BODY)
	var id2 = Sim.make_body(10, 10, Vector2(100, 100), Vector2(0, 0), Body.BodyType.SMALL_BODY)
	add_body(Sim.get_body_by_id(id1))
	add_body(Sim.get_body_by_id(id2))

func _physics_process(delta: float) -> void:
	Sim.update_step(delta)
	for id in self.bodies:
		if id not in Sim.bodies:
			remove_body_by_id(id)
			continue
		self.bodies[id].position = Sim.bodies[id].position

	for id in Sim.bodies:
		if id not in self.bodies:
			add_body(Sim.get_body_by_id(id))
			
