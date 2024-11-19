extends Node


const MAX_HEALTH = 100

var health = 100
var coins = 0
var player_position: Vector2 = Vector2(600, 376) 
var current_quests: Dictionary = {}
var items: Array[String] = []
var enemy_to_load = null 
var special_ammo_item = false
var player_died = false

func increase_health(value: int):
	health = clamp(health + value, 0, MAX_HEALTH)
	HUD.update_health(health)

func decrease_health(value: int):
	health = clamp(health - value, 0, MAX_HEALTH)
	HUD.update_health(health)
	
func add_coins(value: int):
	#print(coins + value)
	if((coins+value)>=0):
		coins += value
		HUD.update_coins(coins)

func add_item(item: String):
	items.append(item)

func del_item(item: String):
	items.erase(item)

func add_quest(quest: Node2D) -> void:
	if !current_quests.has(quest.id):
		current_quests[quest.id] = quest


func complete_quest(quest: Node2D) -> void:
	if current_quests.has(quest.id):
		quest.is_completed = true
		#print("Quest completed: ", quest.name)

func restart():
	health=100
	HUD.update_health(health)
