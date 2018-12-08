extends Area2D
# set lever timeout
export (NodePath) var lever
export(float) var timeout

var activated = false

func activate():
	if not activated:
		get_node(lever).timeout = timeout
		activated = true
		$polygon.position.y += 4
		$shape.disabled = true

func _on_button_body_entered(body):
	activate()

