extends Button

## On-screen hold button that feeds an input action while pressed.
##
## Handles raw touch events itself instead of relying on the Button's
## mouse-based pressed signals, so it works on real touchscreens even with
## "emulate_mouse_from_touch" disabled. On desktop "emulate_touch_from_mouse"
## turns mouse clicks into screen-touch events, so the same path works there.

## The input action (from Project Settings -> Input Map) to drive.
@export var action: String = ""

var _touch_index := -1

func _input(event: InputEvent) -> void:
	if action == "":
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			if _touch_index == -1 and get_global_rect().has_point(event.position):
				_touch_index = event.index
				button_pressed = true
				Input.action_press(action)
				get_viewport().set_input_as_handled()
		elif event.index == _touch_index:
			_touch_index = -1
			button_pressed = false
			Input.action_release(action)
			get_viewport().set_input_as_handled()
