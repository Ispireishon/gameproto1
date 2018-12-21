extends Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_spikes_body_entered(body):
	if body.is_in_group('damageable'):
		body.get_damage(1)