extends Node2D

func _ready() -> void:
	position = Vector2(0, 0)
	z_index = 50
	
func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	
func _on_quit_button_pressed():
	HUD.check_visibility()
	SceneTransition.change_scene_with_fade("res://scenes/world.tscn")
