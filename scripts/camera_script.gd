extends Camera2D

@export var follow_object: Node2D
@export var smoothing_speed: float = 3.5  

@export var shake_intensity: float = 2.0  
@export var shake_duration: float = 0.13  
@export var shake_speed: float = 2  

var original_position: Vector2
var shaking: bool = false

func _ready():
	position = PlayerState.player_position
	original_position = position

func _process(delta: float) -> void:
	if not follow_object:
		return

	var target_position = follow_object.position
	var distance = target_position.distance_to(position)

	if distance < 1.0:
		position = target_position
	else:
		position = position.lerp(target_position, smoothing_speed * delta)

	if shaking:
		return

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
		if get_tree() != null:
			await get_tree().create_timer(shake_tween_duration).timeout 
	if get_tree() != null:
		await get_tree().create_timer(shake_duration).timeout
	position = original_position
	shaking = false
