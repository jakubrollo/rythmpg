extends CanvasLayer

func change_scene_with_fade(target_scene: String) -> void:
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target_scene)
	$AnimationPlayer.play_backwards("fade_out")
