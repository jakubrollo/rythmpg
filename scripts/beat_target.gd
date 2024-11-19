extends Area2D


var correctlyPressed = false
var current_beat_signal

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	correctlyPressed = true
	current_beat_signal = body
	
func _on_body_exited(body: Node2D) -> void:
	correctlyPressed = false
	current_beat_signal = null

func get_current_beat_signal() -> Node2D:
	return current_beat_signal
