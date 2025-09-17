
extends RigidBody2D

#@export var motor_torque: float = 6200.0  # try 1500–4000 depending on your masses
func _physics_process(_delta: float) -> void:
	"""
	var dir := 0.0
	if Input.is_action_pressed("drive_right"):
		dir += 1.0

	if Input.is_action_pressed("drive_left"):
		dir -= 1.0

	if dir != 0.0:
		# Apply torque around the wheel’s center (positive = CCW)
		apply_torque(motor_torque * dir)
		"""
		
	pass
