extends Node2D

@export var grid_path: NodePath                 # sätt till din BuildGrid-nod
@export var placeable_scene: PackedScene        # sätt till Placeable.tscn
@export var continuous_place: bool = true       # fortsätt placera efter klick

@onready var grid: Node = get_node_or_null(grid_path)

var ghost: Node2D = null
var current_cell: Vector2i = Vector2i.ZERO
var current_data: Dictionary
var rotation_steps: int = 0

func _ready() -> void:
	if grid == null:
		push_error("ObjectPlacer: Grid Path är inte satt eller pekar fel.")
	if placeable_scene == null:
		push_error("ObjectPlacer: Placeable Scene är inte satt.")

func begin_placing(data: Dictionary) -> void:
	if grid == null or placeable_scene == null:
		return
	_cancel()
	current_data = data
	rotation_steps = 0
	print(data)

	ghost = placeable_scene.instantiate()
	add_child(ghost)
	if ghost.has_method("configure"):
		ghost.call("configure", data, true) # ghost = förhandsvisning
	_apply_rotation_to_ghost()

func _process(_dt: float) -> void:
	if ghost == null or grid == null:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var cell: Vector2i = grid.world_to_cell(mouse_pos)
	current_cell = cell
	ghost.global_position = grid.cell_to_world(cell)
	_apply_rotation_to_ghost()

	var ok: bool = grid.is_free(cell)
	var base_alpha := 0.5
	if ok:
		ghost.modulate = Color(1, 1, 1, base_alpha)
	else:
		ghost.modulate = Color(1, 0.4, 0.4, base_alpha)

func _unhandled_input(event: InputEvent) -> void:
	if ghost == null or grid == null:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if grid.is_free(current_cell):
			_place_current()
			if not continuous_place:
				_cancel()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_cancel()

	if event.is_action_pressed("rotate_right"):
		rotation_steps = (rotation_steps + 1) % 4
	if event.is_action_pressed("rotate_left"):
		rotation_steps = (rotation_steps + 3) % 4

func _place_current() -> void:
	if placeable_scene == null or grid == null:
		return
	var placed: Node2D = placeable_scene.instantiate()
	get_parent().add_child(placed)
	placed.global_position = grid.cell_to_world(current_cell)
	if placed.has_method("configure"):
		placed.call("configure", current_data, false)
	grid.mark(current_cell, true)

func _apply_rotation_to_ghost() -> void:
	if ghost:
		ghost.rotation = float(rotation_steps) * PI / 2.0

func _cancel() -> void:
	if ghost:
		ghost.queue_free()
	ghost = null
	current_data = {}
	rotation_steps = 0
