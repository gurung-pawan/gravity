extends Control

var is_menu_visible: bool = true
@onready var edit_container: VBoxContainer = $PanelContainer/MarginContainer/MenuContainer/EditContainer
signal cleared

@export var mass_edit: SpinBox
@export var radius_edit: LineEdit
@export var velX_edit: LineEdit
@export var velY_edit: LineEdit

func _ready() -> void:
	mass_edit.get_line_edit().text_changed.connect(func(_t): mass_edit.apply())

func _on_show_menu_toggled(toggled_on: bool) -> void:
	self.is_menu_visible = toggled_on
	if self.is_menu_visible: edit_container.show()
	else: edit_container.hide()


func _on_button_button_up() -> void:
	cleared.emit()