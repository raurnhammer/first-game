extends CanvasLayer

# On-Screen-Buttons fuer Touch/Maus. Sie loesen die normalen Input-Actions aus,
# sodass der Player-Controller unveraendert bleibt.

@onready var left_button = $Control/LeftButton
@onready var right_button = $Control/RightButton
@onready var jump_button = $Control/JumpButton

# Mappt jeden aktiven Finger (touch index) auf die Action, die er gerade haelt.
# Noetig, damit links/rechts UND jump gleichzeitig moeglich sind – die
# Maus-Emulation kann immer nur einen Finger abbilden.
var _touch_actions := {}

func _ready():
	# Desktop: Maus laeuft ueber die normalen Button-Signale.
	_bind(left_button, "move_left")
	_bind(right_button, "move_right")
	_bind(jump_button, "jump")

func _bind(button, action):
	button.button_down.connect(func(): Input.action_press(action))
	button.button_up.connect(func(): Input.action_release(action))

func _input(event):
	# Mobile: echte Multitouch-Events, jeder Finger einzeln.
	if event is InputEventScreenTouch:
		if event.pressed:
			_press_finger(event.index, event.position)
		else:
			_release_finger(event.index)
	elif event is InputEventScreenDrag:
		# Finger ist von einem Button auf einen anderen (oder ins Leere) gerutscht.
		if _touch_actions.get(event.index, "") != _action_at(event.position):
			_release_finger(event.index)
			_press_finger(event.index, event.position)

func _press_finger(index, pos):
	var action = _action_at(pos)
	if action == "":
		return
	Input.action_press(action)
	_touch_actions[index] = action

func _release_finger(index):
	if _touch_actions.has(index):
		Input.action_release(_touch_actions[index])
		_touch_actions.erase(index)

func _action_at(pos) -> String:
	if left_button.get_global_rect().has_point(pos):
		return "move_left"
	if right_button.get_global_rect().has_point(pos):
		return "move_right"
	if jump_button.get_global_rect().has_point(pos):
		return "jump"
	return ""
