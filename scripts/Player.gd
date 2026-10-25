extends CharacterBody2D

class_name Player

@export var speed: float = 12
@export var camera: Camera2D
@export var floating_text_scene: PackedScene

var is_moving = false
signal moved

const TILE_SIZE = 16
const MOVE_INTERVAL = 0.2

var lose_screen = preload("res://scenes/LoseScreen.tscn")

const inputs = {
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
}

var last_dir = Vector2.ZERO
var last_action = ""
var cacti_damage = 10

var original_color

func _ready():
	original_color = $Sprite2D.modulate
	# Align position to the middle of a tile
	position.x = int(PlayerState.player_position.x / TILE_SIZE) * TILE_SIZE
	position.y = int(PlayerState.player_position.y / TILE_SIZE) * TILE_SIZE
	position += Vector2.ONE * TILE_SIZE / 2
	
	# Set timer interval based on speed
	$MoveTimer.wait_time = MOVE_INTERVAL
	$MoveTimer.start()

func _unhandled_input(event):
	# When the player presses a movement key, update the direction
	for action in inputs:
		if event.is_action_pressed(action):
			var dir = inputs[action]
			if not is_moving:
				# Move immediately if not already moving
				move_tile(dir)
				last_action = action
				last_dir = dir
				$MoveTimer.start()  # Start the timer for continuous movement

func move_tile(direction: Vector2):
	$RayCast2D.target_position = direction * TILE_SIZE
	$RayCast2D.force_raycast_update()

	if is_moving:
		return
	
	if $RayCast2D.is_colliding():
		var other = $RayCast2D.get_collider()
		if other.has_method("on_collide"):
			other.on_collide(self)
		return
	
	var target_position = position + direction * TILE_SIZE
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 1.0 / speed)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	is_moving = false
	moved.emit()

# movement while key is held down
func _on_MoveTimer_timeout():
	
	if last_action != "" and Input.is_action_pressed(last_action):
		if not is_moving:
			move_tile(last_dir)
	else:
		last_action = ""
		last_dir = Vector2.ZERO
		$MoveTimer.stop()

func get_hurt(damage):
	PlayerState.decrease_health(damage)
	flash_red()
	if floating_text_scene:
		var floating_text = floating_text_scene.instantiate()
		get_tree().current_scene.add_child(floating_text)
		var random_offset = Vector2(randi_range(-15, 15), randi_range(-8,8))
		floating_text.show_text(damage, position + Vector2(0, -10) + random_offset)
		
	camera.trigger_shake()
	
	if(PlayerState.health<= 0):
		var lose_instance = lose_screen.instantiate()
		PlayerState.player_died = true
		SceneTransition.change_scene_with_fade("res://scenes/World.tscn")
		

func collect_coins(value):
	PlayerState.add_coins(value)
	
func remove_coins(amount: int):
	PlayerState.add_coins(max(0, amount))

func flash_red():
	$Sprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = original_color
