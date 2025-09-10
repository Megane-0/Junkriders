extends Control

@onready var product_grid : GridContainer = $VBoxContainer/ScrollContainer/ProductGrid

@export var shop_item : PackedScene

var store_item_id : int = 0
var shop_data : Array = [
	{
		"name": "Wooden Box",
		"type": "block",
		"icon_path": "res://icons/wood_box.png",
		"price": 5,
		"quantity": 10
	},
	{
		"name": "Metal Box",
		"type": "block",
		"icon_path": "res://icons/metal_box.png",
		"price": 15,
		"quantity": 5
	},
	{
		"name": "Small Wheel",
		"type": "wheel",
		"icon_path": "res://icons/small_wheel.png",
		"price": 10,
		"quantity": 8
	},
	{
		"name": "Large Wheel",
		"type": "wheel",
		"icon_path": "res://icons/large_wheel.png",
		"price": 20,
		"quantity": 4
	},
	{
		"name": "Propeller",
		"type": "engine",
		"icon_path": "res://icons/propeller.png",
		"price": 30,
		"quantity": 2
	},
	{
		"name": "Rocket Booster",
		"type": "engine",
		"icon_path": "res://icons/rocket.png",
		"price": 50,
		"quantity": 1
	},
		{
		"name": "Rocket Booster",
		"type": "engine",
		"icon_path": "res://icons/rocket.png",
		"price": 50,
		"quantity": 1
	}
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_store()
	
func setup_store() -> void:
	product_grid.columns = 3

	for data in shop_data:
		var temp = shop_item.instantiate()
		temp.item_buy_pressed.connect(on_item_buy_pressed)
		product_grid.add_child(temp)
		temp.setup(data, store_item_id)
		store_item_id += 1

func on_item_buy_pressed(id: int) -> void:
	print("item with id ", id, " Bought")
	
