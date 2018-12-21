extends Node

func _process(delta):
	pass

func _unhandled_input(event):
	if pressed_key(event) == KEY_ESCAPE:
		get_tree().quit() # Could handle this later. Now using default project prop "Auto accept quit"
	if pressed_key(event) == KEY_1:
		get_tree().change_scene("res://Scenes/main.tscn")
	if pressed_key(event) == KEY_2:
		get_tree().change_scene("res://Scenes/main2.tscn")
	if pressed_key(event) == KEY_3:
		get_tree().change_scene("res://Scenes/main3.tscn")
	if pressed_key(event) == KEY_4:
		get_tree().change_scene("res://Scenes/main4.tscn")

	
func pressed_key(event):
	if event is InputEventKey:
		if event.pressed:
			return event.scancode