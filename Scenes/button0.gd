extends Area2D

export(Array, NodePath) var connects
export(float) var timeout

func activate():
	for c in connects:
		c = get_node(c)
		if c.is_in_group('activate'):
			c.activate()
	$polygon.position.y = 4
	$timeout.wait_time = timeout
	$timeout.start()

func _on_button_body_entered(body):
	activate()

func _on_timeout_timeout():
	$polygon.position.y = 0
	for c in connects:
		c = get_node(c)
		if c.is_in_group('activate'):
			c.disactivate()
