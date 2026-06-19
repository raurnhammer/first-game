extends Node

var score = 0

@onready var beer_meter = $TouchControls/Control/BeerMeter

func add_point():
	score += 1
	beer_meter.add_beer()
