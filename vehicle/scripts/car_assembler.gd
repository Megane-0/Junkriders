# CarAssembler2D.gd (Godot 4.x)
extends Node2D
class_name CarAssembler2D

@export var tile_size: Vector2 = Vector2(64, 64)
@export var chassis_block_scene: PackedScene
@export var wheel_scene: PackedScene

@export var weld_softness: float = 0.002
@export var axle_softness: float = 0.002

# Prefer which neighbor to attach a wheel to
var wheel_attach_order: Array[Vector2i] = [
	Vector2i(0, -1),  # above
	Vector2i(-1, 0),  # left
	Vector2i(1, 0),   # right
	Vector2i(0, 1),   # below
]

# grid is Array of rows; each row is an Array of cell strings ("C","W",".")
func build_car(grid: Array, origin: Vector2 = Vector2.ZERO) -> Dictionary:
	var car_root := Node2D.new()
	car_root.name = "Car"
	add_child(car_root)

	# Typed containers
	var chassis_at: Dictionary[Vector2i, RigidBody2D] = {}
	var chassis_list: Array[RigidBody2D] = []
	var wheel_list: Array[RigidBody2D] = []

	# 1) Spawn chassis blocks
	for y in range(grid.size()):
		var row: Array = grid[y]
		for x in range(row.size()):
			var cell := str(row[x])
			if cell == "C":
				var ch := chassis_block_scene.instantiate() as RigidBody2D
				ch.position = origin + Vector2(x, y) * tile_size
				car_root.add_child(ch)
				ch.add_to_group("vehicle_chassis")
				chassis_at[Vector2i(x, y)] = ch
				chassis_list.append(ch)

	# 2) Weld adjacent chassis (only right & down to avoid duplicates)
	var dirs: Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1)]
	for pos: Vector2i in chassis_at.keys():
		for d: Vector2i in dirs:
			var other: Vector2i = pos + d
			if chassis_at.has(other):
				_weld(car_root, chassis_at[pos], chassis_at[other], d)

	# 3) Spawn wheels and pin to nearest chassis neighbor
	for y in range(grid.size()):
		var row2: Array = grid[y]
		for x in range(row2.size()):
			var cell2 := str(row2[x])
			if cell2 == "W":
				var w := wheel_scene.instantiate() as RigidBody2D
				w.position = origin + Vector2(x, y) * tile_size
				car_root.add_child(w)
				w.add_to_group("vehicle_wheel")
				wheel_list.append(w)

				var neighbor := _find_neighbor_chassis(chassis_at, Vector2i(x, y))
				if neighbor:
					var j := PinJoint2D.new()
					j.node_a = neighbor.get_path()
					j.node_b = w.get_path()
					j.position = w.position      # axle at wheel center
					j.disable_collision = true
					j.softness = axle_softness
					car_root.add_child(j)
				else:
					push_warning("Wheel at %s has no neighboring chassis." % Vector2i(x, y))

	return {"root": car_root, "chassis": chassis_list, "wheels": wheel_list}


# Two pins at separated points ≈ rigid weld
func _weld(parent: Node, a: RigidBody2D, b: RigidBody2D, dir: Vector2i) -> void:
	var mid := (a.position + b.position) * 0.5
	var offset: Vector2 = Vector2(0, tile_size.y * 0.25) if dir.x != 0 else Vector2(tile_size.x * 0.25, 0)
	for sgn in [-1.0, 1.0]:
		var j := PinJoint2D.new()
		j.node_a = a.get_path()
		j.node_b = b.get_path()
		j.position = mid + offset * sgn
		j.disable_collision = true
		j.softness = weld_softness
		parent.add_child(j)

# Explicitly typed dictionary + temp variable
func _find_neighbor_chassis(map: Dictionary[Vector2i, RigidBody2D], p: Vector2i) -> RigidBody2D:
	for d: Vector2i in wheel_attach_order:
		var k: Vector2i = p + d
		if map.has(k):
			return map[k]
	return null
	
	# Returns: Dictionary[Vector2i, int] -> how many wheels would attach to that chassis cell
func preview_wheel_attachment_counts(grid: Array) -> Dictionary[Vector2i, int]:
	var chassis_cells: Dictionary[Vector2i, bool] = {}
	var counts: Dictionary[Vector2i, int] = {}

	# record where chassis are
	for y in range(grid.size()):
		var row: Array = grid[y]
		for x in range(row.size()):
			if str(row[x]) == "C":
				pass

	# simulate attachments using the same neighbor priority
	for y in range(grid.size()):
		var row2: Array = grid[y]
		for x in range(row2.size()):
			if str(row2[x]) == "W":
				var p := Vector2i(x, y)
				for d in wheel_attach_order:
					var k := p + d
					if chassis_cells.has(k):
						counts[k] = counts.get(k, 0) + 1
						break
						
	return counts
		
