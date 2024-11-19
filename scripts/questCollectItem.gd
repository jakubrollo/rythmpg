extends Quest

@export var item: String

func _ready():
	condition = Callable(self, "_has_item")
	on_complete = Callable(self, "_give_reward")
	start = Callable(self, "_start_quest")
#	reward = Callable(self, "_reward_player")

func _has_item() -> bool:
	return PlayerState.items.has(item)

func _give_reward() -> void:
	PlayerState.del_item(item)
	is_completed = true
	PlayerState.special_ammo_item = true
	print("Quest completed! Given special ammo item")
	
func _start_quest() -> void:
	print("Quest started!")

#func _reward_player() -> void:
#	print("reward")
