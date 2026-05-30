extends Node2D

@export var min_zoom: float = 0.001
@export var max_zoom: float = 200.0
@export var zoom_speed: float = 0.1
@export var drag_speed: float = 1.0

var is_pressed: bool = false

@onready var camera: Camera2D = $Camera2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_pressed = event.pressed
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_towards_mouse(1.0 + zoom_speed)
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_towards_mouse(1.0 / (1.0 + zoom_speed))

	elif event is InputEventMouseMotion and is_pressed:
		camera.position -= event.relative * drag_speed / camera.zoom.x

func _zoom_towards_mouse(zoom_factor: float) -> void:
	var mouse_world_pos_before = get_global_mouse_position()
	var new_zoom = clamp(camera.zoom.x * zoom_factor, min_zoom, max_zoom)
	camera.zoom = Vector2(new_zoom, new_zoom)
	
	var mouse_world_pos_after = get_global_mouse_position()
	camera.position += mouse_world_pos_before - mouse_world_pos_after