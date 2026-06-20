extends Node2D

const BeerMeterItemScene = preload("res://scenes/beer_meter_item.tscn")

@export var maxBeer: int = 1
@export var item_scale: float = 4.0
@export var spacing: float = 64.0
@export var start_position: Vector2 = Vector2(32, 32)

var beers: int = 0
var beer_items: Array = []

@onready var container = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Nur die Hintergrundleiste auf die volle Breite ziehen – auf Android ist
	# die Viewport-Breite durch stretch aspect "expand" groesser als die 640er-Basis.
	container.size.x = get_viewport().get_visible_rect().size.x
	# Die Glaeser bleiben links eng beieinander (festes spacing).
	for i in range(maxBeer):
		var item = BeerMeterItemScene.instantiate()
		item.scale = Vector2(item_scale, item_scale)
		item.position = start_position + Vector2(spacing * i, 0)
		container.add_child(item)
		item.empty_beer()
		beer_items.append(item)

func add_beer() -> void:
	if beers >= maxBeer:
		return
	beer_items[beers].fill_beer()
	beers += 1
