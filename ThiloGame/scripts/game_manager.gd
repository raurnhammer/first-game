extends Node

const HappyBirthdayScene = preload("res://scenes/happy_birthday.tscn")

var score = 0
var _celebrated := false
# Zeitpunkt des Spielstarts in Millisekunden.
var _start_time := 0

@export var timeToCelebrate: float = 1.0

@onready var beer_meter = $TouchControls/Control/BeerMeter

func _ready() -> void:
	_start_time = Time.get_ticks_msec()

func add_point():
	score += 1
	beer_meter.add_beer()
	# Alle Beers gesammelt -> nach kurzer Pause Happy-Birthday-Szene einblenden.
	if not _celebrated and score >= beer_meter.maxBeer:
		_celebrated = true
		var elapsed := (Time.get_ticks_msec() - _start_time) / 1000.0
		# Kleine Pause, damit das letzte Bier noch wahrgenommen wird.
		await get_tree().create_timer(timeToCelebrate).timeout
		var win = HappyBirthdayScene.instantiate()
		add_child(win)
		win.show_result(beer_meter.maxBeer, elapsed)
