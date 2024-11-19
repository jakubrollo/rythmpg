extends CharacterBody2D

@export var messages: Array[String] = []
var is_active = false
var current_message_index = 0
@export var quest_to_give: Node2D
@export var enemy_script: Script
@export var thank_you: String = "Thank you!"

func _ready() -> void:
	if messages.size() > 0:
		$CanvasLayer/TextureRect/Label.text = messages[0]
	else:
		$CanvasLayer/TextureRect/Label.text = ""

func _unhandled_input(event):
	if is_active and event.is_action_pressed("ui_accept"): 
		progress_dialog()

func progress_dialog():
	if quest_to_give and PlayerState.current_quests.has(quest_to_give.id):
		handle_existing_quest()
	else:
		handle_default_dialog()

func handle_existing_quest():
	var quest = PlayerState.current_quests[quest_to_give.id]
	if quest.is_completed:
		show_message("You've already helped me!")
	elif quest.condition.call() && quest.is_started:
		quest.on_complete.call()
		show_message(thank_you)
	else:
		handle_next_message()

func handle_default_dialog():
	handle_next_message()

func handle_next_message():
	if current_message_index < messages.size() - 1:
		current_message_index += 1
		show_message(messages[current_message_index])
	else:
		end_dialog()

func show_message(text: String):
	$CanvasLayer/TextureRect/Label.text = text

func end_dialog():
	if is_active:
		$CanvasLayer/AnimationPlayer.play_backwards("info_fade_in")
		is_active = false
		current_message_index = 0
		
		if quest_to_give and !PlayerState.current_quests.has(quest_to_give.id):
			var new_quest = quest_to_give.duplicate()
			new_quest.id = quest_to_give.id
			new_quest._ready()
			PlayerState.add_quest(new_quest) 
			var quest = PlayerState.current_quests[quest_to_give.id]
			quest.is_started = true 
			quest.start.call()

func _on_close_area_body_entered(body):
	if body.is_in_group("Player"):
		$CanvasLayer/AnimationPlayer.play("info_fade_in")
		is_active = true
		current_message_index = 0
		if messages.size() > 0:
			$CanvasLayer/TextureRect/Label.text = messages[0]
			
		if (enemy_script):
			PlayerState.enemy_to_load = enemy_script

func _on_close_area_body_exited(body):
	if body.is_in_group("Player"):
		end_dialog()
