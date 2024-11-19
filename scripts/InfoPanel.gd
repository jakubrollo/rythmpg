extends StaticBody2D


@export var message: String = ""


func _ready():
	$CanvasLayer/TextureRect/Label.text = message

func _on_close_area_body_entered(body):
	if body.is_in_group("Player"):
		$CanvasLayer/AnimationPlayer.play("info_fade_in")


func _on_close_area_body_exited(body):
	if body.is_in_group("Player"):
		$CanvasLayer/AnimationPlayer.play_backwards("info_fade_in")
