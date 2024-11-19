extends CanvasLayer

@export var coins_label: Label 
@export var health_bar: ProgressBar
@export var damage_bar: ProgressBar
@export var health_color: Color = Color(0.0, 1.0, 0.0)
@export var damage_color: Color = Color(1.0, 0.0, 0.0) 

var current_coin_count: int = PlayerState.coins  

func _ready():
	check_visibility()

func check_visibility():
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name == "World":
		visible = true 
	else:
		visible = false

func update_coins(new_coin_count: int):

	var tween_duration = 0.5  
	var tween = create_tween()
	tween.tween_method(_current_coin_interpolation, current_coin_count, new_coin_count, tween_duration)
	current_coin_count = new_coin_count

func _current_coin_interpolation(coin_value: int):
	coins_label.text = "Coins: " + str(coin_value)

func update_health(amount: float):
	var tween = create_tween()
	tween.tween_property(health_bar, "value", amount, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	if amount < health_bar.value:
		damage_bar.value = health_bar.value
		damage_bar.modulate = damage_color
		tween.tween_property(damage_bar, "value", amount, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		damage_bar.value = 0
		damage_bar.modulate = health_color

	if amount == health_bar.max_value:
		health_bar.modulate = health_color
