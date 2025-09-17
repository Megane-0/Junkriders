extends Node2D

var data: Dictionary
var is_ghost := false

@onready var visual: Sprite2D = $Visual
@onready var collider: CollisionShape2D = $Collider

func configure(d: Dictionary, ghost: bool=false) -> void:
	data = d
	is_ghost = ghost

	# 1) Sprite
	var tex_path: String = d.get("icon_path", d.get("icon_path", ""))
	print(tex_path)
	var tex = null
	if tex_path != "":
		tex = load(tex_path)
		if tex == null:
			tex = load("res://icon.svg")
			

	if tex:
		visual.texture = tex

	visual.modulate.a = (0.5 if ghost else 1.0)



	var s := RectangleShape2D.new()
	var size: Vector2 = Vector2(128,128)
	s.size = size
	collider.shape = s

	# 3) Footprint (hur många gridceller den tar)
	# Använd t.ex. data["footprint"] = Vector2i(w,h); här markerar du bara i gridet vid placering.
