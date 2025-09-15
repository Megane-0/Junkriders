extends Node2D

func _ready() -> void:
	var grid: Array = [
		[".",".",".",".","."],
		[".","C","C","C","W"],
		[".","W","","W","."],
	]

	# 1) PREVIEW: check for chassis that would get more than one wheel
	var counts: Dictionary[Vector2i, int] = $CarAssembler2D.preview_wheel_attachment_counts(grid)
	var ok := true
	for k: Vector2i in counts.keys():
		if counts[k] > 1:
			ok = false
			push_warning("Chassis at %s would get %d wheels (limit is 1)." % [k, counts[k]])

	# 2) Abort (or let the player fix the layout) if invalid
	if not ok:
		return  # stop here; don't build

	# 3) Build and attach controller
	var car_info: Dictionary = $CarAssembler2D.build_car(grid, Vector2(300, 220))
	$VehicleController.attach_to(car_info["root"])
