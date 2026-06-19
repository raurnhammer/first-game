extends CanvasLayer

# Unsichtbarer "Floating Joystick" fuer Touch/Maus.
#
# Egal wo eine Beruehrung beginnt: dieser Punkt ist das Zentrum. Der Versatz
# des Fingers vom Zentrum steuert die Figur:
#   - nach links/rechts ziehen  -> move_left / move_right
#   - nach oben ziehen          -> jump
# Horizontale und vertikale Achse sind unabhaengig, daher ergibt sich
# "hoch-rechts" = Sprung + nach rechts ganz automatisch.
#
# Die Tastatur (Pfeile / A,D / Leertaste) laeuft weiter ueber die normalen
# Input-Actions und wird hier nicht angefasst.

## Ausschlag in Pixeln, ab dem links/rechts ausgeloest wird.
@export var move_threshold: float = 24.0
## Ausschlag nach oben in Pixeln, ab dem gesprungen wird.
@export var jump_threshold: float = 40.0

# Index des Fingers, der gerade den Joystick steuert (-1 = keiner).
var _finger := -1
# Bildschirmposition, an der die Beruehrung begann (= Joystick-Zentrum).
var _origin := Vector2.ZERO
# Aktuell gehaltene Actions, damit wir nur bei Aenderung pressen/releasen
# (noetig, damit is_action_just_pressed beim Sprung genau einmal ausloest).
var _active := {}

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _finger == -1:
				_finger = event.index
				_origin = event.position
				_apply({})
		elif event.index == _finger:
			_finger = -1
			_apply({})
	elif event is InputEventScreenDrag and event.index == _finger:
		_update(event.position - _origin)

# Wandelt den Versatz vom Zentrum in gehaltene Actions um.
func _update(offset: Vector2) -> void:
	var wanted := {}
	if offset.x <= -move_threshold:
		wanted["move_left"] = true
	elif offset.x >= move_threshold:
		wanted["move_right"] = true
	if offset.y <= -jump_threshold:
		wanted["jump"] = true
	_apply(wanted)

# Setzt die Eingaben so, dass genau die Actions in "wanted" gehalten werden.
func _apply(wanted: Dictionary) -> void:
	for action in _active.keys():
		if not wanted.has(action):
			Input.action_release(action)
	for action in wanted.keys():
		if not _active.has(action):
			Input.action_press(action)
	_active = wanted
