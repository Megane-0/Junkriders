# res://parts/VehiclePart.gd
extends RigidBody2D
class_name VehiclePart

@export var part_id: StringName
@export var icon: Texture2D
@export var footprint: Array[Vector2i] = [Vector2i(0,0)]  # grid cells it occupies
@export var mount_points: Array[Vector2i] = []            # relative neighbor cells it can attach to
@export var max_joint_force: float = 0.0  # 0 = unbreakable (you can use later)

func on_assembled(_car_root: Node) -> void:
	# hook for parts that need setup once spawned
	pass
