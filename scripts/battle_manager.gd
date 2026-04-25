extends Node

@onready var battle_end_panel: Panel = $CanvasLayer/BattleEndPanel
@onready var battle_end_text: RichTextLabel = $CanvasLayer/BattleEndPanel/BattleEndText

@onready var player_actions: HBoxContainer = $"CanvasLayer/Player Actions"

# Basic Actions
@onready var basic_actions: VBoxContainer = $"CanvasLayer/Player Actions/Basic Actions"
@onready var basic_attack_button: Button = $"CanvasLayer/Player Actions/Basic Actions/Basic Attack Button"
@onready var brace_button: Button = $"CanvasLayer/Player Actions/Basic Actions/Brace Button"

# Skills
@onready var skills: VBoxContainer = $"CanvasLayer/Player Actions/Skills"
@onready var triple_swipe_button: Button = $"CanvasLayer/Player Actions/Skills/Triple Swipe Button"
@onready var charge_attack_button: Button = $"CanvasLayer/Player Actions/Skills/Charge Attack Button"
@onready var double_strike_button: Button = $"CanvasLayer/Player Actions/Skills/Double Strike Button"

# Abilities
@onready var abilities: VBoxContainer = $"CanvasLayer/Player Actions/Abilities"
@onready var heal_button: Button = $"CanvasLayer/Player Actions/Abilities/Heal Button"
@onready var haste_button: Button = $"CanvasLayer/Player Actions/Abilities/Haste Button"
@onready var atk_up_button: Button = $"CanvasLayer/Player Actions/Abilities/ATK UP Button"

# Player Health
@onready var player_health: VBoxContainer = $"CanvasLayer/Player Health"
@onready var player_name: Label = $"CanvasLayer/Player Health/Player Name"
@onready var player_health_bar: ProgressBar = $"CanvasLayer/Player Health/Player Health Bar"
@onready var player_hp_label: Label = $"CanvasLayer/Player Health/Player Health Bar/Player HP Label"
@onready var self_use_button: Button = $"CanvasLayer/Player Health/Self Use Button"

# Player Status Effects
@onready var player_status_effect_label: VBoxContainer = $"CanvasLayer/Player Status Effect Label"
@onready var player_status_label: Label = $"CanvasLayer/Player Status Effect Label/Player Status Label"
@onready var player_effect_1: Label = $"CanvasLayer/Player Status Effect Label/Player Effect 1"
@onready var player_effect_2: Label = $"CanvasLayer/Player Status Effect Label/Player Effect 2"
@onready var player_effect_3: Label = $"CanvasLayer/Player Status Effect Label/Player Effect 3"

# Enemy Health
@onready var enemy_health: VBoxContainer = $"CanvasLayer/Enemy Health"
@onready var enemy_name: Label = $"CanvasLayer/Enemy Health/Enemy Name"
@onready var enemy_health_bar: ProgressBar = $"CanvasLayer/Enemy Health/Enemy Health Bar"
@onready var enemy_hp_label: Label = $"CanvasLayer/Enemy Health/Enemy Health Bar/Enemy HP Label"
@onready var enemy_use_button: Button = $"CanvasLayer/Enemy Health/Enemy Use Button"

# Enemy Status Effects
@onready var enemy_status_effect_label: VBoxContainer = $"CanvasLayer/Enemy Status Effect Label"
@onready var enemy_status_label: Label = $"CanvasLayer/Enemy Status Effect Label/Enemy Status Label"
@onready var enemy_effect_1: Label = $"CanvasLayer/Enemy Status Effect Label/Enemy Effect 1"
@onready var enemy_effect_2: Label = $"CanvasLayer/Enemy Status Effect Label/Enemy Effect 2"
@onready var enemy_effect_3: Label = $"CanvasLayer/Enemy Status Effect Label/Enemy Effect 3"

# Cancel Option
@onready var cancel_action: HBoxContainer = $"CanvasLayer/Cancel Action"
@onready var selected_label: Label = $"CanvasLayer/Cancel Action/Selected Label"
@onready var action_name: Label = $"CanvasLayer/Cancel Action/Action Name"
@onready var cancel_action_button: Button = $"CanvasLayer/Cancel Action/Cancel Action Button"

# QTE
@onready var qte_background: Sprite2D = $QTEBackground
@onready var player_qte: Sprite2D = $Player_QTE

@onready var qte_pressed: AnimatedSprite2D = $QTE_Pressed
@onready var qte_icon_player: Sprite2D = $QTE_Icon_Player
@onready var qte_icon_enemy: Sprite2D = $QTE_Icon_Enemy


@onready var qte_start: Marker2D = $"QTE Start"
@onready var qte_hit_early: Marker2D = $"QTE Hit Early"
@onready var qte_hit_late: Marker2D = $"QTE Hit Late"
@onready var qte_miss: Marker2D = $"QTE Miss"
@onready var qte_getting_hit_buffer: Marker2D = $"QTE Getting Hit Buffer"
@onready var qte_early_hit: Marker2D = $"QTE Early Hit"


const EnemyPlayerAbilities = preload("res://scripts/enemy_player_abilities.gd")

var all_battlers = []
var player_battlers = []
var enemy_battlers = []

var current_turn : Node2D
var current_turn_index : int
var attack_type: String

# Variable for QTE Speed
var qte_speed: int = 1.5

# Variable to 
var qte_attack = []

# Holds the QTE attack list
var qte_queue = []

var evade_frames: float = 0
var parry_frames: float = 0
var parry_count: int
var parry_extra_turn: bool

var qte_target: String = ""

func _ready() -> void:
	set_process(false)
	player_actions.hide()
	battle_end_panel.hide()
	
	player_battlers = get_tree().get_nodes_in_group("PlayerBattler")
	enemy_battlers = get_tree().get_nodes_in_group("EnemyBattler")
	all_battlers.append_array(player_battlers)
	all_battlers.append_array(enemy_battlers)
	
	all_battlers.sort_custom(_sort_turn_order_ascending)
	
	brace_button.pressed.connect(_player_braced)
	basic_attack_button.pressed.connect(_basic_attack)
	triple_swipe_button.pressed.connect(player_skill_attack.bind("triple_swipe"))
	charge_attack_button.pressed.connect(player_skill_attack.bind("charge_attack"))
	double_strike_button.pressed.connect(player_skill_attack.bind("double_strike"))
	heal_button.pressed.connect(player_ability.bind("heal"))
	haste_button.pressed.connect(player_ability.bind("haste"))
	atk_up_button.pressed.connect(player_ability.bind("atk_up"))
	
	for p in player_battlers:
		p.turn_ended.connect(_next_turn)
		p.dead.connect(_on_player_dead)
		p.update_health.connect(_update_health_bar)
		
	for e in enemy_battlers:
		e.be_selected.connect(_attack_selected_enemy)
		e.dead.connect(_on_enemy_dead)
		e.deal_damage.connect(_attack_random_player_battler)
		e.update_health.connect(_update_health_bar)
		
	current_turn = all_battlers[current_turn_index]
	_update_health_bar()
	_update_turn()
	
func _process(delta: float) -> void:
	if qte_queue.is_empty():
		set_process(false)
		await get_tree().create_timer(0.5).timeout
		evade_frames = 0
		parry_frames = 0
		qte_pressed.play("RESET")
		_next_turn()
	
	if evade_frames > 0:
		evade_frames -= delta
	if parry_frames > 0:
		parry_frames -= delta
		
	# Determines QTE Speed
	for i in qte_queue:
		if is_instance_valid (i):
			i.position.x -= qte_speed
	
	#   PLAYER ATTACKING ENEMY
	
	# If QTE is for the Player attacking the Enemy
	if qte_target == "EnemyBattler" and !qte_queue.is_empty():
		
		# If the QTE is missed by the player entirely
		if qte_queue[0].position.x <= qte_miss.position.x:
			print("Attack Failed")
			qte_queue[0].free()
			qte_queue.pop_at(0)
			
		if Input.is_action_just_pressed("parry"):
			qte_pressed.play("Parry")
			parry_frames = 0.1
			if qte_queue[0].position.x <= qte_hit_early.position.x and qte_queue[0].position.x >= qte_hit_late.position.x:
				print("Attack Successful")
				current_turn.start_attacking(enemy_battlers[0], qte_attack[0][1])
				qte_queue[0].free()
				qte_queue.pop_at(0)
			elif qte_queue[0].position.x < qte_hit_early.position.x or qte_queue[0].position.x > qte_hit_late.position.x and qte_queue[0].position.x <= qte_early_hit.position.x:
				print("Attack Mistimed")
				qte_queue[0].free()
				qte_queue.pop_at(0)
				
		if parry_frames <= 0:
			qte_pressed.play("RESET")
	
	#   ENEMY ATTACKING PLAYER
	
	# QTE for the Enemy attacking the Player
	if qte_target == "PlayerBattler" and !qte_queue.is_empty():
		
		# If the Player successfully times their evade, then the attack misses the player
		if qte_queue[0].position.x <= qte_hit_early.position.x and qte_queue[0].position.x >= qte_hit_late.position.x:
			if evade_frames > 0:
				print("Evaded!")
				qte_queue[0].position.x -= 50
			elif parry_frames > 0:
				print("Parried!")
				qte_queue[0].free()
				qte_queue.pop_at(0)
			
		if !qte_queue.is_empty() and is_instance_valid(qte_queue[0]):
			# If the Player fails to redirect the enemy attack
			if qte_queue[0].position.x > qte_hit_late.position.x and qte_queue[0].position.x <= qte_getting_hit_buffer.position.x:
				print("Player Hit!")
				enemy_battlers[0].start_attacking(player_battlers[0], qte_attack[0][1])
				qte_queue[0].free()
				qte_queue.pop_at(0)
				
			# If the attack goes past the player
			else:
				if qte_queue[0].position.x <= qte_miss.position.x:
					qte_queue[0].free()
					qte_queue.pop_at(0)
		
		# PLAYER INPUT HANDLERS
		if evade_frames <= 0 and parry_frames <= 0:
			# Player Block Handler
			if Input.is_action_pressed("block"):
				qte_pressed.play("Block")
				if qte_queue[0].position.x <= qte_hit_early.position.x and qte_queue[0].position.x >= qte_hit_late.position.x:
					print("Blocked")
					enemy_battlers[0].start_attacking(player_battlers[0], qte_attack[0][1] * 0.75)
					qte_queue[0].free()
					qte_queue.pop_at(0)
			
			# Player Evade Handler
			elif Input.is_action_just_pressed("evade"):
				qte_pressed.play("Evade")
				evade_frames = 1
				
			elif Input.is_action_just_pressed("parry"):
				qte_pressed.play("Parry")
				parry_frames = 0.1
					
			# If no input is active, then reset the player input feedback animation
			else:
				if !qte_pressed.animation == "RESET":
					qte_pressed.play("RESET")
	
# Determines who goes
func _sort_turn_order_ascending(battler_1, battler_2) -> bool:
	if battler_1.stats_resource.turn_speed < battler_2.stats_resource.turn_speed:
		return true
	return false
	
# Updates Current Turn
func _update_turn() -> void:
	if current_turn.stats_resource.type == BattlerStats.BattlerType.PLAYER:
		player_actions.show()
	else:
		player_actions.hide()
		
	current_turn.start_turn()
	
func _next_turn() -> void:
	qte_background.hide()
	qte_pressed.hide()
	player_qte.hide()
	qte_target = ""
	attack_type = ""
	parry_count = 0
	if player_actions.visible:
		player_actions.hide()
	if is_instance_valid(current_turn):
		current_turn.stop_turn()
	if _check_for_battle_end() == false:
		current_turn_index = (current_turn_index + 1) % all_battlers.size()
		current_turn = all_battlers[current_turn_index]
		_update_turn()

func _basic_attack() -> void:
	attack_type = "basic"
	_show_target_buttons()

func _show_target_buttons() -> void:
	player_actions.hide()
	for e in enemy_battlers:
		e.show_select_button()
		
func _hide_target_buttons() -> void:
	player_actions.hide()
	for e in enemy_battlers:
		e.hide_select_button()
		
func _player_braced() -> void:
	current_turn.start_brace()

func _attack_selected_enemy(selected_enemy : Node2D) -> void:
	_hide_target_buttons()
	if (attack_type == "basic"):
		current_turn.basic_attack(selected_enemy)
	elif (attack_type == "triple_swipe"):
		_start_qte(selected_enemy, EnemyPlayerAbilities.player_attack_triple_strike)
	elif (attack_type == "charge_attack"):
		_start_qte(selected_enemy, EnemyPlayerAbilities.player_attack_charge)
	elif (attack_type == "double_strike"):
		_start_qte(selected_enemy, EnemyPlayerAbilities.player_double_strike)
	else:
		current_turn.basic_attack(selected_enemy)
	
func _start_qte(selected_enemy: Node2D, attack) -> void:
	qte_attack = attack
	qte_target = selected_enemy.get_name()
	qte_background.show()
	qte_pressed.show()
	player_qte.show()
	for i in qte_attack:
		if qte_target == "PlayerBattler":
			var instance = qte_icon_enemy.duplicate(true)
			add_child(instance)
			qte_queue.append(instance)
			instance.show()
			instance.position = Vector2(qte_start.position.x + (i[0] * 100),qte_start.position.y)
		else:
			var instance = qte_icon_player.duplicate(true)
			add_child(instance)
			qte_queue.append(instance)
			instance.show()
			instance.position = Vector2(qte_start.position.x + (i[0] * 100),qte_start.position.y)
	set_process(true)
	
# Attack Player	
func _attack_random_player_battler(damage: int) -> void:
	var enemy_attack_array = [EnemyPlayerAbilities.bandit_attack_charge, EnemyPlayerAbilities.bandit_attack_triple, EnemyPlayerAbilities.bandit_attack_two_offbeat]
	var rand = randi_range(0, 2)
	_start_qte(player_battlers[0], enemy_attack_array[rand])
	
func _on_enemy_dead(dead_enemy: Node2D) -> void:
	enemy_battlers.erase(dead_enemy)
	all_battlers.erase(dead_enemy)
	
func _on_player_dead(dead_battler: Node2D) -> void:
	player_battlers.erase(dead_battler)
	all_battlers.erase(dead_battler)
	
func _check_for_battle_end() -> bool:
	if enemy_battlers.is_empty():
		_show_battle_end_panel("Player won!")
		return true
	elif player_battlers.is_empty():
		_show_battle_end_panel("Player lost!")
		return true
	return false
	
func _show_battle_end_panel(message : String) -> void:
	battle_end_text.clear()
	battle_end_text.append_text("[center]%s" % [message])
	battle_end_panel.show()
	if player_actions.visible:
		player_actions.hide()

# GUI CODE
func player_skill_attack(skill):
	match skill:
		"triple_swipe":
			attack_type = "triple_swipe"
			_show_target_buttons()
		"charge_attack":
			attack_type = "charge_attack"
			_show_target_buttons()
		"double_strike":
			attack_type = "double_strike"
			_show_target_buttons()
func player_ability(ability):
	match ability:
		"heal":
			print("player used heal")
		"haste":
			print("player used haste")
		"atk_up":
			print("player used atk up")

func _hide_player_buttons() -> void:
	player_actions.hide()
	
func _show_player_buttons() -> void:
	player_actions.show()
	
func _hide_cancel_button() -> void:
	cancel_action.hide()
	
func _show_cancel_button() -> void:
	cancel_action.show()
	
func _toggle_use_button(target, state) -> void:
	if (target == "player" & state == "hide"):
		self_use_button.hide()
	elif (target == "player" & state == "show"):
		self_use_button.show()
	elif (target == "enemy" & state == "hide"):
		enemy_use_button.hide()
	else:
		enemy_use_button.show()
		
# Remains Unused for now.
func _show_status_effect(target) -> void:
	match target:
		"player":
			player_status_effect_label.show()
		"enemy":
			enemy_status_effect_label.show()

func _hide_status_effect(target) -> void:
	match target:
		"player":
			player_status_effect_label.hide()
		"enemy":
			enemy_status_effect_label.hide()

func _update_health_bar() -> void:
	if !player_battlers.is_empty():
		player_health_bar.max_value = player_battlers[0].health_bar.max_value
		player_health_bar.value = player_battlers[0].health_bar.value
		player_hp_label.text = "HP:%d/%d" % [player_battlers[0].health_bar.value, player_battlers[0].health_bar.max_value]
	if !enemy_battlers.is_empty():
		enemy_health_bar.max_value = enemy_battlers[0].health_bar.max_value
		enemy_health_bar.value =enemy_battlers[0].health_bar.value
		enemy_hp_label.text = "HP:%d/%d" % [enemy_battlers[0].health_bar.value, enemy_battlers[0].health_bar.max_value]
