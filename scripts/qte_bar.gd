extends Node2D

@export var player_battler : BattlerStats

@onready var background: Sprite2D = $Background
@onready var qte_circle: Sprite2D = $"QTE Circle"
@onready var qte: Sprite2D = $QTE
@onready var qte_start: Marker2D = $"QTE Start"
@onready var qte_hit_early: Marker2D = $"QTE Hit Early"
@onready var qte_hit_late: Marker2D = $"QTE Hit Late"
@onready var qte_miss: Marker2D = $"QTE Miss"

var direction = 1

func _process(delta: float) -> void:
	
	if qte.position.x <= qte_start.position.x:
		direction = 1
	elif qte.position.x >= qte_miss.position.x:
		direction = -1
		
		qte.position.x += direction
		
		if Input.is_action_pressed("ui_accept"):
			if qte.position.x >= qte_hit_early.position.x and qte.position.x <= qte_hit_late.position.x:
				print("attacked target")
