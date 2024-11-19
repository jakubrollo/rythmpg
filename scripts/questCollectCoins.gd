extends Quest

@export var coins_required: int = 1000

func _ready():
	condition = Callable(self, "_has_coins_amount")
	on_complete = Callable(self, "_give_reward")
	start = Callable(self, "_start_quest")
#	reward = Callable(self, "_reward_player")

func _has_coins_amount() -> bool:
	return PlayerState.coins >= coins_required

func _give_reward() -> void:
	PlayerState.add_coins(-1000)
	is_completed = true
	#print("Quest completed!")
	
func _start_quest() -> void:
	pass
	#print("Quest started!")
#func _reward_player() -> void:
#	print("reward")
