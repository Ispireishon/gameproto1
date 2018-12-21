extends Area2D

export (Array, NodePath) var connects

func activate():
	if connects:
		if $polygon.scale.x > 0:
			for c in connects:
				c = get_node(c)
				if c.is_in_group('activate'):
					c.activate()
		else:
			for c in connects:
				c = get_node(c)
				if c.is_in_group('activate'):
					c.disactivate()
	
	$polygon.scale.x *= -1