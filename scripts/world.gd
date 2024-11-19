extends Node2D

func _ready() -> void:
	HUD.check_visibility() 
	#print($Player.position)
	$Player.position = PlayerState.player_position
	if !PlayerState.current_quests.has(1):
		set_npc_invisible($NPC)
	if !PlayerState.current_quests.has(1) || !PlayerState.current_quests[1].is_completed:
		set_npc_invisible($NPC2)
		set_npc_invisible($NPC3)
	
	if PlayerState.player_died:
		PlayerState.restart()
		PlayerState.player_died = false
		
func set_npc_invisible(node: Node):
	node.propagate_call("set_visible", [false])
	node.get_node("CollisionShape2D").disabled = true
