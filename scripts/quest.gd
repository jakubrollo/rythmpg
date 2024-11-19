extends Node2D
class_name Quest
@export var condition: Callable
@export var on_complete: Callable
@export var start: Callable
@export var id: int
var is_started: bool = false  
var is_completed: bool = false
#@export var reward: Callable
#@export var completion_message: String = "Quest complete!"
