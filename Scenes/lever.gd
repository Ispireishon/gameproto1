extends Area2D

export(Array, NodePath) var connects
export(float) var timeout

func activate():
	if scale.x > 0:
		for c in connects:
			c = get_node(c)
			if c.is_in_group('activate'):
				c.activate()
		scale.x = -abs(scale.x)
		$timeout.wait_time = timeout
		$timeout.start()



func _on_timeout_timeout():
	scale.x = abs(scale.x)
	for c in connects:
		c = get_node(c)
		if c.is_in_group('activate'):
			c.disactivate()
