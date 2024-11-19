extends Camera2D

var original_position: Vector2
var shaking: bool = false

@export var shake_intensity: float = 2.0  
@export var shake_duration: float = 0.13  
@export var shake_speed: float = 2  

func _ready() -> void:
	position = Vector2(0,0)
	original_position = position

func _process(delta: float) -> void:
	pass

func trigger_shake():
	if shaking:
		return  

	shaking = true

	original_position = position

	var shake_end_time = Time.get_ticks_msec() + (shake_duration * 1000)
	var shake_tween_duration = shake_duration / 10.0

	for i in range(10):
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		var tween = create_tween()
		tween.tween_property(self, "position", original_position + random_offset, shake_tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await get_tree().create_timer(shake_tween_duration).timeout  

	await get_tree().create_timer(shake_duration).timeout
	position = original_position
	shaking = false
