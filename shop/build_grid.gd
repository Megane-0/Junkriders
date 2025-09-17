extends Node2D

@export var cell_size: int = 128
@export var grid_width: int = 5
@export var grid_height: int = 3
@export var top_margin: int = 24   # distance from top of screen

@export var grid := []

func _ready() -> void:
	add_to_group("build_grid")  # <-- lägg till denna rad
	_update_position()
	reset_grid(grid_height, grid_width)
	queue_redraw()
	
func reset_grid(height: int, width: int) -> void:
	grid = []
	for row in range(height):
		grid.append([])
		for col in range(width):
			grid[row].append(0)

func _process(_dt: float) -> void:
	# keep centered if window size changes
	_update_position()

func _update_position() -> void:
	var vp := get_viewport_rect().size
	var grid_px := Vector2(grid_width * cell_size, grid_height * cell_size)
	# place the grid's TOP-LEFT so the grid is centered horizontally
	global_position = Vector2((vp.x - grid_px.x) * 0.5, top_margin)

# ------- cell/world conversion (relative to this node) -------
func world_to_cell(p: Vector2) -> Vector2i:
	var local := p - global_position
	return Vector2i(floor(local.x / cell_size), floor(local.y / cell_size))

func cell_to_world(c: Vector2i) -> Vector2:
	# center of the cell in world/screen coords
	return global_position + Vector2(c.x * cell_size + cell_size * 0.5,
									 c.y * cell_size + cell_size * 0.5)

func is_inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < grid_width and cell.y >= 0 and cell.y < grid_height

func is_free(cell: Vector2i) -> bool:
	return is_inside(cell) and grid[cell.y][cell.x] == 0

func mark(cell: Vector2i, taken: int) -> void:
	if is_inside(cell):
		grid[cell.y][cell.x] = taken

# ------- visual grid -------
var show_grid := true # Currently not used

func _draw() -> void:
	if not show_grid:
		return
	for x in range(grid_width + 1):
		var xpx := float(x * cell_size)
		draw_line(Vector2(xpx, 0), Vector2(xpx, grid_height * cell_size), Color(1,1,1,0.2))
	for y in range(grid_height + 1):
		var ypx := float(y * cell_size)
		draw_line(Vector2(0, ypx), Vector2(grid_width * cell_size, ypx), Color(1,1,1,0.2))
