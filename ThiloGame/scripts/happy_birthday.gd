extends CanvasLayer

# Win-Screen: Leertaste oder Touch/Klick startet das Spiel von vorn.
#
# Wir nutzen _input (laeuft vor der GUI), damit der bildschirmfuellende
# Hintergrund den Touch nicht abfaengt. Alle Eingaben sind flankengesteuert
# (nur "pressed"), ein noch gehaltener Sprung-Knopf loest also nicht sofort
# einen Neustart aus.

@onready var result_label = $ResultLabel

# Setzt den Ergebnistext: Anzahl Bier + benoetigte Zeit in Sekunden.
func show_result(count: int, seconds: float) -> void:
	result_label.text = "Trotz dieses hohen Alters\nhast Du gerade %d Bier in %d sec getrunken.\n\nHut ab!" % [count, int(round(seconds))]

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_SPACE:
			_restart()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_restart()

func _restart() -> void:
	get_tree().reload_current_scene()
