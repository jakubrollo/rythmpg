extends Node2D

# State variables
var action_phase = "clap"  
var action_count = 0
var clap_count = 0
var beat_count = 2
var first_signal_in_pair = true
var game_ended = false

# Player and Enemy state
var player_lives = 3
var player_action = ""
var reloads_in_row = 0
var has_ammo = false
var machine_gun_ready = false
var player_original_color

var enemy_original_color

# Action press counts
var is_action_pressed_once = {"reload": false, "defend": false, "shoot": false}
var last_action = ""

# UI elements
var beat_signal = preload("res://scenes/beat_signal.tscn")
var beat_signal_clap = preload("res://scenes/beat_signal_clap.tscn")

var win_screen = preload("res://scenes/WinScreen.tscn")
var lose_screen = preload("res://scenes/LoseScreen.tscn")
@onready var target = $BeatTarget
@onready var player = $Player
@onready var enemy = $Enemy
@onready var ammo_sprite = $UI/Ammo
@onready var shield_sprite = $UI/Shield
@onready var player_hearts = [$UI/PlayerHearts/Heart1, $UI/PlayerHearts/Heart2, $UI/PlayerHearts/Heart3]
@onready var enemy_hearts = [$UI/EnemyHearts/Heart1, $UI/EnemyHearts/Heart2, $UI/EnemyHearts/Heart3]

func _ready():
	if PlayerState.enemy_to_load:
		var enemy = $Enemy  # Path to your enemy node
		enemy.set_script(PlayerState.enemy_to_load)
		
	if PlayerState.special_ammo_item:
		has_ammo=true
		
	player_original_color = player.modulate
	enemy_original_color = enemy.modulate
	$Conductor.play_with_beat_offset(5)
	HUD.check_visibility()
	update_ui()

func _process(delta: float) -> void:
	if game_ended:  # Stop gameplay when the game is over
		return
	
	var current_signal = target.get_current_beat_signal()
	if target.correctlyPressed and !current_signal.alreadyUsed:
		if Input.is_action_just_pressed("clap"):
			current_signal.get_node("AnimationPlayer").play("target_hit_correctly") 
			player.play("clap")
			current_signal.alreadyUsed = true
			if action_phase == "clap":
				clap()
		elif action_phase == "action":
			handle_action_input(current_signal)

func handle_action_input(current_signal: Node2D) -> void:
	for action in ["reload", "defend", "shoot"]:
		if Input.is_action_just_pressed(action):
			current_signal.get_node("AnimationPlayer").play("target_hit_correctly") 
			handle_action(action)
			current_signal.alreadyUsed = true

func handle_action(action: String) -> void:
	if action != last_action:
		for key in is_action_pressed_once.keys():
			is_action_pressed_once[key] = false
		last_action = action

	if clap_count == 2:
		player.play(action)
		if is_action_pressed_once[action]:
			player_action = action
			match action:
				"reload": reload()
				"defend": defend()
				"shoot": 
					if has_ammo or machine_gun_ready: 
						shoot()
					else:
						player_action = "stand"
			is_action_pressed_once[action] = false
		else:
			is_action_pressed_once[action] = true
		update_ui()

func clap():
	#print("Clap!")
	clap_count += 1

func reload():
	#print("Reloading...")
	reloads_in_row += 1
	has_ammo = true
	if reloads_in_row == 5:
		#print("Machine gun ready!")
		machine_gun_ready = true

func defend():
	#print("Defending...")
	reloads_in_row = 0

func shoot():
	#print("Machine gun firing! Unblockable shots." if machine_gun_ready else "Bang! Bang!")
	has_ammo = false
	reloads_in_row = 0
	machine_gun_ready = false

func evaluate_actions():
	if game_ended:
		return
	match [player_action, enemy.action]:
		["shoot", "reload"], ["shoot", "stand"]: 
			enemy.take_damage(1)
			$Camera2D.trigger_shake()
			flash_red(enemy, enemy_original_color)
		["reload", "shoot"], ["stand", "shoot"]:
			player_lives -= 1
			flash_red(player, player_original_color)
			$Camera2D.trigger_shake()
		_: pass
	check_game_over()
	update_ui()

func check_game_over():
	if player_lives <= 0:
		game_ended = true
		show_lose_screen()
	elif enemy.lives <= 0:
		game_ended = true
		show_win_screen()

func _on_Conductor_beat(_position): pass

func _on_Conductor_measure(_position):
	if game_ended:
		return
	
	_spawn_note() if (beat_count / 2) % 2 == 0 else _spawn_note_clap()
	beat_count += 1

func _spawn_note():
	var instance = beat_signal.instantiate()
	add_child(instance)

func _spawn_note_clap():
	var instance = beat_signal_clap.instantiate()
	instance.clap = true
	add_child(instance)

	
func _on_beat_target_body_exited(body: Node2D):
	player.play("stand")
	if body.clap:
		if not first_signal_in_pair:
			#print("now action!")
			update_enemy_action()
			action_phase = "action"
			first_signal_in_pair = true
			player_action = "stand"
		else:
			first_signal_in_pair = false
	else:
		if not first_signal_in_pair:
			evaluate_actions()
			#print("now clap!")
			player.play("stand")
			action_phase = "clap"
			first_signal_in_pair = true
		else:
			first_signal_in_pair = false

	if action_phase == "clap" and first_signal_in_pair:
		clap_count = 0

func update_enemy_action():
	enemy.update_action()
	update_ui()

func update_ui():
	ammo_sprite.modulate.a = 1.0 if has_ammo else 0.5
	shield_sprite.modulate.a = 1.0 if player_action == "defend" else 0.5

	for i in range(player_lives, 3):
		player_hearts[i].modulate.a = 0.5
	for i in range(player_lives):
		player_hearts[i].modulate.a = 1.0

	for i in range(enemy.lives, 3):
		enemy_hearts[i].modulate.a = 0.5
	for i in range(enemy.lives):
		enemy_hearts[i].modulate.a = 1.0

func show_win_screen():
	var win_instance = win_screen.instantiate()
	enemy.give_reward()
	get_tree().current_scene.add_child(win_instance)

func show_lose_screen():
	var lose_instance = lose_screen.instantiate()
	get_tree().current_scene.add_child(lose_instance)
	
func flash_red(object, original_color):
	object.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	object.modulate = original_color
