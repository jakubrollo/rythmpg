extends Area2D

@export var amount: int
@export var size_duration: float = 2.0  

var original_scale: Vector2
var tween: Tween

func _ready():
	original_scale = scale  
	tween = create_tween()  

	animate_size()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect_coins(amount)
		queue_free()

func animate_size():
	var random_offset = randf_range(0.0, 0.5)
	tween.tween_property(self, "scale", original_scale * 1.2, size_duration + random_offset).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", original_scale, size_duration + random_offset).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.set_loops(0)
