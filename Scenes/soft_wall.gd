extends StaticBody2D

func activate():
	collision_layer = 0
	$shape.disabled = true
	hide()

func disactivate():
	collision_layer = 1
	$shape.disabled = false
	show()