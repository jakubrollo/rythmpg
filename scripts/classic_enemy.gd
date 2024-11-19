extends AnimatedSprite2D

var lives = 1
var action = ""
var cycle = ["defend", "reload", "shoot"]  
var action_index = 0  
var original_color

@export var reward: int = 1000

func _ready():
	original_color = modulate

func update_action():
	action = cycle[action_index]
	action_index = (action_index + 1) % cycle.size()
	play(action)

func take_damage(damage):
	lives -= damage

func give_reward():
	PlayerState.add_coins(reward)
