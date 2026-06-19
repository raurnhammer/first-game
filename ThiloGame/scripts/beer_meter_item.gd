extends Node2D

@onready var beer_sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beer_sprite.frame = 1

func fill_beer() -> void:
	beer_sprite.frame = 0

func empty_beer() -> void:
	beer_sprite.frame = 1
