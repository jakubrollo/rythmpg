extends Area2D


@export var next_scene: String = "res://scenes/House.tscn"
@export var message: String = "Press SPACE to enter."
@export var teleport_return_position: Vector2 = Vector2.ZERO
@export var return_to_same_pos:bool = false

var is_active = false

func _ready():
	$CanvasLayer/TextureRect/Label.text = message

func _unhandled_input(event):
	if event.is_action_pressed("Action") and is_active:
		var player = get_node("../../Player")
		if return_to_same_pos:
			teleport_return_position = player.position
		PlayerState.player_position = teleport_return_position
		SceneTransition.change_scene_with_fade(next_scene)

func _on_close_area_body_entered(body):
	if body.is_in_group("Player"):
		$CanvasLayer/AnimationPlayer.play("info_fade_in2")
		is_active = true


func _on_close_area_body_exited(body):
	if body.is_in_group("Player"):
		$CanvasLayer/AnimationPlayer.play_backwards("info_fade_in2")
		is_active = false
