extends Node2D

var BodyScene = preload("res://scenes/body.tscn")

@onready var bodies_node: Node = $BodiesNode
@export var ui: Control

var time_scale = SimConfig.TIME_SCALE

var bodies: Dictionary[int, Node2D] = {}

func add_body(body: Body):
	var bodyNode = BodyScene.instantiate()
	bodyNode.init(body.id, body.mass, body.radius, body.position, body.type)
	self.bodies[body.id] = bodyNode
	bodies_node.add_child(bodyNode)

func remove_body_by_id(_id: int):
	for body_node in self.bodies_node.get_children():
		if body_node.id == _id:
			self.bodies_node.remove_child(body_node)
			break
	self.bodies.erase(_id)

func _physics_process(delta: float) -> void:
	Sim.update_step(self.time_scale * delta)

	for id in self.bodies.keys():  # .keys() returns a copy
		if id not in Sim.bodies:
			remove_body_by_id(id)
			continue
		self.bodies[id].position = Sim.bodies[id].position

	for id in Sim.bodies:
		if id not in self.bodies:
			add_body(Sim.get_body_by_id(id))

### UI FUNCTIONS ###
func _input(event: InputEvent) -> void:

	var SCALED_MASS = 100_000
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var n_position = get_global_mouse_position()
			var n_mass = ui.mass_edit.value
			var n_radius = ui.radius_edit.text.to_float()
			var n_vel_x = ui.velX_edit.text.to_float()
			var n_vel_y = ui.velY_edit.text.to_float()

			var id = Sim.make_body(n_mass * SCALED_MASS, n_radius, n_position, Vector2(n_vel_x, n_vel_y))
			add_body(Sim.get_body_by_id(id))


func _on_ui_cleared() -> void:
	Sim.clear_bodies()

