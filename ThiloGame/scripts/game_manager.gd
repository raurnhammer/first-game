extends Node

const HappyBirthdayScene = preload("res://scenes/happy_birthday.tscn")

var score = 0
var _celebrated := false

@onready var beer_meter = $TouchControls/Control/BeerMeter

func add_point():
	score += 1
	beer_meter.add_beer()
	# Alle Beers gesammelt -> Happy-Birthday-Szene mit Konfetti einblenden.
	if not _celebrated and score >= beer_meter.maxBeer:
		_celebrated = true
		add_child(HappyBirthdayScene.instantiate())
