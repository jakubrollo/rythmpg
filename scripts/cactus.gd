extends StaticBody2D

func on_collide(other: Node2D):
	if other is Player:
		other.get_hurt(randi_range(7,12))
		
