# VehicleController.gd
extends Node2D

@export var motor_torque := 6200.0
@export var max_wheel_omega := 25.0   # rad/s; 0 = unlimited
@export var drive_only_named: Array[StringName] = []  # optional: names to drive (empty = all wheels)
var wheels: Array[RigidBody2D] = []

func attach_to(car_root: Node) -> void:
	wheels.clear()
	for n in car_root.get_children():
		if n is RigidBody2D and n.is_in_group("vehicle_wheel"):
			if drive_only_named.is_empty() or (n.name in drive_only_named):
				wheels.append(n)
	print("VehicleController: wheels attached = ", wheels.size())

func _wake(body: RigidBody2D) -> void:
	if body.sleeping:
		body.sleeping = false
		# PhysicsServer2D.body_wakeup(body.get_rid())  # optional

func _physics_process(_d: float) -> void:
	if wheels.is_empty(): return
	var dir := int(Input.is_action_pressed("drive_right")) - int(Input.is_action_pressed("drive_left"))
	if dir == 0: return
	for w in wheels:
		if not is_instance_valid(w): continue
		if max_wheel_omega <= 0.0 or absf(w.angular_velocity) < max_wheel_omega:
			_wake(w)
			w.apply_torque(motor_torque * dir)
