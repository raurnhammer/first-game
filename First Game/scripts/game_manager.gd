extends Node

var score = 0

@onready var score_label = $"../TouchControls/Control/ScoreLabel"

func add_point():
	score += 1
	score_label.text = str(score) + " of 10 beers"
