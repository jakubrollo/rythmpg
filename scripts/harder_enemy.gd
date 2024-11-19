extends AnimatedSprite2D

var lives = 3
var action = ""
var cycle = ["reload", "defend", "shoot", "defend"]  
var action_index = 0  
var original_color

@export var reward: String = "Cactus"

func _ready():
	original_color = modulate

func update_action():
	action = cycle[action_index]
	action_index = (action_index + 1) % cycle.size()
	play(action)

func take_damage(damage):
	lives -= damage

func give_reward():
	PlayerState.add_item(reward)
