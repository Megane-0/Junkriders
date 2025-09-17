extends Control

signal item_buy_pressed(id)

var id : int

@onready var button = $VBoxContainer/Product
@onready var price = $VBoxContainer/Price


func setup(data : Dictionary):
	var texture = load(data.get("icon_path"))
	if texture == null:
		texture = load("res://icon.svg")
	button.texture_normal = texture
	price.text = "Price: " + str(data.get("price"))
	id = data.get("id")
	

func _on_product_pressed():
	emit_signal("item_buy_pressed", id)
