extends CharacterBody2D

var speed = 0.0
var bpm = 98 

var spawn_y = -360
var target_y = 139  # centre of BeatTarget, so the note sits on the target exactly on the beat
var spawn = Vector2(get_viewport_rect().size.x / 2, spawn_y)
var dist_to_target = target_y - spawn_y
	

signal on_target_hit
var clap = false

var alreadyUsed = false

func initialize():
	position=spawn
	var beat_duration = 60.0 / bpm
	speed = (dist_to_target / (4*beat_duration))
	
func _ready() -> void:
	initialize()

func _process(delta: float) -> void:
	position.y += speed * delta
	
	if position.y > get_viewport_rect().size.y:
		queue_free()

func _on_BeatSignal_body_entered(body):
	if body.name == "BeatTarget":
		emit_signal("on_target_hit")
		queue_free() 
