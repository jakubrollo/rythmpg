extends Label

@export var float_duration: float = 1.5 
@export var float_distance: float = 50 
@export var start_size: float = 17.0 
@export var end_size: float = 1.0  
@export var text_color: Color = Color(1, 0, 0) 


func show_text(value: int, start_position: Vector2):
	text = str(value)
	position = start_position
	modulate = text_color

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position:y", position.y - float_distance, float_duration)
	tween.tween_property(self, "modulate:a", 0.0, float_duration)
	tween.tween_property(self, "theme_override_font_sizes/font_size", end_size, float_duration)
