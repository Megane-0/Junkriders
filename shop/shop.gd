extends Control

@onready var product_grid : GridContainer = $VBoxContainer/ProductGrid

@export var shop_item : PackedScene

var shop_data : Array  = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_item_data("res://data/item_data.json")
	setup_store()

func load_item_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_ARRAY:
			shop_data = result
	
func setup_store() -> void:
	product_grid.columns = 3

	for data in shop_data:
		var temp = shop_item.instantiate()
		temp.item_buy_pressed.connect(on_item_buy_pressed)
		product_grid.add_child(temp)
		temp.setup(data)

func on_item_buy_pressed(id: int) -> void:
	print("item with id ", id, " Bought")
	
