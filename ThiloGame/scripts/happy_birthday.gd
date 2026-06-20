extends CanvasLayer

# Win-Screen: Leertaste oder Touch/Klick startet das Spiel von vorn.
#
# Wir nutzen _input (laeuft vor der GUI), damit der bildschirmfuellende
# Hintergrund den Touch nicht abfaengt. Alle Eingaben sind flankengesteuert
# (nur "pressed"), ein noch gehaltener Sprung-Knopf loest also nicht sofort
# einen Neustart aus.

@onready var result_label = $ResultLabel

func _ready() -> void:
	# Layout an die echte Viewport-Groesse anpassen (wichtig fuer stretch
	# aspect "expand" auf Android, wo der sichtbare Bereich breiter ist als
	# die 640x480-Basisaufloesung).
	_layout()
	get_viewport().size_changed.connect(_layout)

# Skaliert/positioniert Hintergrund, Bild, Konfetti und Text auf die
# aktuelle Viewport-Groesse.
func _layout() -> void:
	var vs := get_viewport().get_visible_rect().size
	$Background.position = Vector2.ZERO
	$Background.size = vs
	$Confetti.screen_size = vs
	# Bild leicht ueber der Mitte halten (wie zuvor 200/480 ~ 0.417).
	$Sprite.position = Vector2(vs.x * 0.5, $Sprite.position.y)
	# Text ueber die volle Breite, am unteren Rand.
	#result_label.offset_left = 20.0
	#result_label.offset_right = vs.x - 20.0
	#result_label.offset_top = vs.y - 140.0
	#result_label.offset_bottom = vs.y - 48.0

# Setzt den Ergebnistext: Anzahl Bier + benoetigte Zeit in Sekunden.
func show_result(count: int, seconds: float) -> void:
	result_label.text = "Trotz dieses hohen Alters\nhast Du gerade %d Bier in %d sec getrunken.\n\nHut ab!" % [count, int(round(seconds))]

func _restart() -> void:
	print("restart")
	get_tree().reload_current_scene()


func _on_again_pressed() -> void:	
	_restart()
