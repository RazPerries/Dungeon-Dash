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

# Sabotage
@onready var sabotage_player_size_down: Sprite2D = $"Sabotage Player Size Down"
@onready var sabotage_enemy_size_down: Sprite2D = $"Sabotage Enemy Size Down"
@onready var sabotage_enemy_attack_speed_up: Sprite2D = $"Sabotage Enemy Attack Speed Up"
@onready var sabotage_player_attack_speed_up: Sprite2D = $"Sabotage Player Attack Speed Up"
@onready var sabotage_player_attack_speed_up_label: Label = $"Sabotage Player Attack Speed Up Label"
@onready var sabotage_enemy_attack_speed_up_label: Label = $"Sabotage Enemy Attack Speed Up Label"
@onready var sabotage_enemy_size_down_label: Label = $"Sabotage Enemy Size Down Label"
@onready var sabotage_player_size_down_label: Label = $"Sabotage Player Size Down Label"

const EnemyPlayerAbilities = preload("res://scripts/enemy_player_abilities.gd")

var all_battlers = []
var player_battlers = []
var enemy_battlers = []

var current_turn : Node2D
var current_turn_index : int
var attack_type: String
var ability_type: String

# Variable for QTE Speed
var qte_speed: int = EnemyPlayerAbilities.qte_speed

# Hold the attack sequence
var qte_attack = []

# QTE attack Array
var qte_queue = []

var evade_frames: float = 0
var parry_frames: float = 0
var parry_count: int = 0
var parry_extra_turn: bool = false

var qte_target: String = ""

var active_sabotages = []

# Player QTE Sabotage
var qte_hit_early_pos

func _ready() -> void:
	set_process(false)
	player_actions.hide()
	battle_end_panel.hide()
	
	qte_hit_early_pos = qte_hit_early.position.x
	
	player_battlers = get_tree().get_nodes_in_group("PlayerBattler")
	enemy_battlers = get_tree().get_nodes_in_group("EnemyBattler")
	all_battlers.append_array(player_battlers)
	all_battlers.append_array(enemy_battlers)
	
	all_battlers.sort_custom(_sort_turn_order_ascending)
	
	brace_button.pressed.connect(player_ability.bind("Brace"))
	basic_attack_button.pressed.connect(_basic_attack)
	triple_swipe_button.pressed.connect(player_skill_attack.bind("Triple Swipe Attack"))
	charge_attack_button.pressed.connect(player_skill_attack.bind("Charge Attack"))
	double_strike_button.pressed.connect(player_skill_attack.bind("Double Strike Attack"))
	heal_button.pressed.connect(player_ability.bind("Heal"))
	haste_button.pressed.connect(player_ability.bind("Haste"))
	atk_up_button.pressed.connect(player_ability.bind("Attack Up"))
	
	self_use_button.pressed.connect(_use_ability)
	
	cancel_action_button.pressed.connect(_cancel_button_pressed)
	
	for p in player_battlers:
		p.turn_ended.connect(_next_turn)
		p.dead.connect(_on_player_dead)
		p.update_health.connect(_update_health_bar)
		
	for e in enemy_battlers:
		e.be_selected.connect(_attack_selected_enemy)
		e.dead.connect(_on_enemy_dead)
		e.deal_damage.connect(_attack_random_player_battler)
		e.update_health.connect(_update_health_bar)
		
	enemy_use_button.pressed.connect(_attack_selected_enemy.bind(enemy_battlers[0]))
		
	current_turn = all_battlers[current_turn_index]
	_update_health_bar()
	_update_turn()
	
# Handes Process based Functions and Mechanics
func _process(delta: float) -> void:
	if qte_queue.is_empty():
		if parry_count == qte_attack.size():
			parry_extra_turn = true
		set_process(false)
		await get_tree().create_timer(0.5).timeout
		evade_frames = 0
		parry_frames = 0
		qte_pressed.play("RESET")
		if current_turn == enemy_battlers[0] and !enemy_battlers.is_empty():
			_clear_sabotages()
			_choose_sabotage(current_turn._get_hp(), current_turn._get_max_hp())
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
			if _enemy_parry() == false:
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
				if _enemy_parry() == false:
					print("Attack Mistimed")
					current_turn.start_attacking(enemy_battlers[0], (qte_attack[0][1] * 0.5))
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
				parry_count += 1
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
					enemy_battlers[0].start_attacking(player_battlers[0], qte_attack[0][1] * 0.80)
					qte_queue[0].free()
					qte_queue.pop_at(0)
			
			# Player Evade Handler
			elif Input.is_action_just_pressed("evade"):
				qte_pressed.play("Evade")
				_give_iframes("Evade")
				
			elif Input.is_action_just_pressed("parry"):
				qte_pressed.play("Parry")
				_give_iframes("Parry")
					
			# If no input is active, then reset the player input feedback animation
			else:
				if !qte_pressed.animation == "RESET":
					qte_pressed.play("RESET")
	
# Determines who goes
func _sort_turn_order_ascending(battler_1, battler_2) -> bool:
	if battler_1.stats_resource.turn_speed < battler_2.stats_resource.turn_speed:
		return true
	return false
	
# Syncs Current Turn
func _update_turn() -> void:
	if current_turn.stats_resource.type == BattlerStats.BattlerType.PLAYER:
		player_actions.show()
	else:
		player_actions.hide()
	current_turn.start_turn()
	
# Updates the Current Turn
func _next_turn() -> void:
	qte_background.hide()
	qte_pressed.hide()
	player_qte.hide()
	qte_target = ""
	attack_type = ""
	ability_type = ""
	parry_count = 0
	if player_actions.visible:
		player_actions.hide()
	if is_instance_valid(current_turn):
		current_turn.stop_turn()
	if _check_for_battle_end() == false:
		if parry_extra_turn and (current_turn == player_battlers[0]):
			_clear_sabotages()
			current_turn = all_battlers[current_turn_index]
			print("Extra Turn!")
			parry_extra_turn = false
		else:
			current_turn_index = (current_turn_index + 1) % all_battlers.size()
			current_turn = all_battlers[current_turn_index]
		_update_turn()

func _give_iframes(type) -> void:
	if type == "Parry":
		if (active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down) > 0):
			parry_frames = (EnemyPlayerAbilities.parry_iframes * (EnemyPlayerAbilities.sabotage_enemy_size_down[1] ** active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down)))
		else:
			parry_frames = EnemyPlayerAbilities.parry_iframes
	if type == "Evade":
		if (active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down) > 0):
			evade_frames = (EnemyPlayerAbilities.evade_iframes * (EnemyPlayerAbilities.sabotage_enemy_size_down[1] ** active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down)))
		else:
			evade_frames = EnemyPlayerAbilities.evade_iframes

func _basic_attack() -> void:
	attack_type = "Basic Attack"
	_show_target_buttons()

func _choose_sabotage(health, max_health) -> void:
	var sabotage_list = [EnemyPlayerAbilities.sabotage_enemy_attack_speed_up, EnemyPlayerAbilities.sabotage_enemy_size_down, EnemyPlayerAbilities.sabotage_player_attack_speed_up, EnemyPlayerAbilities.sabotage_player_size_down]
	var rand = randi_range(0, sabotage_list.size()-1)
	active_sabotages.append(sabotage_list[rand])
	
	# If Health is 50% or lower, add another sabotage
	if (health <= ceil((max_health/2))):
		rand = randi_range(0, sabotage_list.size()-1)
		active_sabotages.append(sabotage_list[rand])
		
	# If Health is 75% or lower, add another sabotage
	if (health <= ceil((max_health/4))):
		rand = randi_range(0, sabotage_list.size()-1)
		active_sabotages.append(sabotage_list[rand])
	
	if active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_attack_speed_up) > 0:
		sabotage_enemy_attack_speed_up.show()
		sabotage_enemy_attack_speed_up_label.text = "x%d" % [active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_attack_speed_up)]
		sabotage_enemy_attack_speed_up_label.show()
		
	if active_sabotages.count(EnemyPlayerAbilities.sabotage_player_size_down) > 0:
		sabotage_player_size_down.show()
		sabotage_player_size_down_label.text = "x%d" % [active_sabotages.count(EnemyPlayerAbilities.sabotage_player_size_down)]
		sabotage_player_size_down_label.show()
		
	if active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down) > 0:
		sabotage_enemy_size_down.show()
		sabotage_enemy_size_down_label.text = "x%d" % [active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down)]
		sabotage_enemy_size_down_label.show()
		
	if active_sabotages.count(EnemyPlayerAbilities.sabotage_player_attack_speed_up) > 0:
		sabotage_player_attack_speed_up.show()
		sabotage_player_attack_speed_up_label.text = "x%d" % [active_sabotages.count(EnemyPlayerAbilities.sabotage_player_attack_speed_up)]
		sabotage_player_attack_speed_up_label.show()
	print(active_sabotages)
	
func _clear_sabotages() -> void:
	active_sabotages = []
	
	sabotage_enemy_attack_speed_up.hide()
	sabotage_enemy_attack_speed_up_label.hide()
	sabotage_player_size_down.hide()
	sabotage_player_size_down_label.hide()
	sabotage_enemy_size_down.hide()
	sabotage_enemy_size_down_label.hide()
	sabotage_player_attack_speed_up.hide()
	sabotage_player_attack_speed_up_label.hide()
	
func _use_ability() -> void:
	_hide_target_buttons()
	_hide_cancel_button()
	_hide_self_button()
	if (ability_type == "Brace"):
		current_turn.start_brace()
	elif (ability_type == "Heal"):
		current_turn._heal_hp(EnemyPlayerAbilities.player_buff_heal_amount)

func _attack_selected_enemy(selected_enemy : Node2D) -> void:
	_hide_target_buttons()
	_hide_cancel_button()
	if (attack_type == "Basic Attack"):
		current_turn.basic_attack(selected_enemy)
	elif (attack_type == "Triple Swipe Attack"):
		_start_qte(selected_enemy, EnemyPlayerAbilities.player_attack_triple_strike)
	elif (attack_type == "Charge Attack"):
		_start_qte(selected_enemy, EnemyPlayerAbilities.player_attack_charge)
	elif (attack_type == "Double Strike Attack"):
		_start_qte(selected_enemy, EnemyPlayerAbilities.player_double_strike)
	
# Handles the Enemy Parrying your Attacks and Dealing damage to you
func _enemy_parry() -> bool:
	var rand = randi_range(0, 100)
	if (rand >= EnemyPlayerAbilities.bandit_parry_chance):
		for i in qte_queue.size():
			qte_queue[0].free()
			qte_queue.pop_front()
		enemy_battlers[0].start_attacking(player_battlers[0], 0.75)
		print("Enemy Parry Attack!")
		return true
	else:
		return false
		
func _start_qte(selected_enemy: Node2D, attack) -> void:
	if current_turn == enemy_battlers[0]:
		await get_tree().create_timer(0.5).timeout
	qte_attack = attack
	qte_target = selected_enemy.get_name()
	qte_background.show()
	qte_pressed.show()
	
	# If Sabotage Player QTE Size Down is Active
	if (active_sabotages.count(EnemyPlayerAbilities.sabotage_player_size_down) > 0):
		var scaling: float = (1 * EnemyPlayerAbilities.sabotage_player_size_down[1] ** active_sabotages.count(EnemyPlayerAbilities.sabotage_player_size_down))
		player_qte.scale = Vector2(scaling,scaling)
		qte_pressed.scale = Vector2(scaling,scaling)
		qte_hit_early.position.x -= (qte_hit_early_pos - player_qte.position.x) * ((1 - EnemyPlayerAbilities.sabotage_player_size_down[1]) * active_sabotages.count(EnemyPlayerAbilities.sabotage_player_size_down))
	else:
		player_qte.scale = Vector2(1,1)
		qte_pressed.scale = Vector2(1,1)
		qte_hit_early.position.x = qte_hit_early_pos
	
	# If Sabotage Enemy Attack Speed Up is Active
	if active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_attack_speed_up) > 0 and qte_target == "PlayerBattler":
		qte_speed = EnemyPlayerAbilities.qte_speed + EnemyPlayerAbilities.sabotage_enemy_attack_speed_up[1] * active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_attack_speed_up)

	# If Sabotage Player Attack Speed Up is Active
	elif active_sabotages.count(EnemyPlayerAbilities.sabotage_player_attack_speed_up) > 0 and qte_target == "EnemyBattler":
		qte_speed = EnemyPlayerAbilities.qte_speed + EnemyPlayerAbilities.sabotage_player_attack_speed_up[1] * active_sabotages.count(EnemyPlayerAbilities.sabotage_player_attack_speed_up)
	else:
		qte_speed = EnemyPlayerAbilities.qte_speed
		
	player_qte.show()
			
	for i in qte_attack:
		if qte_target == "PlayerBattler":
			var instance = qte_icon_enemy.duplicate(true)
			add_child(instance)
			qte_queue.append(instance)
			instance.scale *= (1 * EnemyPlayerAbilities.sabotage_enemy_size_down[1] ** active_sabotages.count(EnemyPlayerAbilities.sabotage_enemy_size_down))
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
	attack_type = skill
	_show_target_buttons()

func player_ability(ability):
	ability_type = ability
	_show_self_button()

# Updates the Health Bars shown in the UI
func _update_health_bar() -> void:
	if !player_battlers.is_empty():
		player_health_bar.max_value = player_battlers[0].health_bar.max_value
		player_health_bar.value = player_battlers[0].health_bar.value
		player_hp_label.text = "HP:%d/%d" % [player_battlers[0].health_bar.value, player_battlers[0].health_bar.max_value]
	if !enemy_battlers.is_empty():
		enemy_health_bar.max_value = enemy_battlers[0].health_bar.max_value
		enemy_health_bar.value =enemy_battlers[0].health_bar.value
		enemy_hp_label.text = "HP:%d/%d" % [enemy_battlers[0].health_bar.value, enemy_battlers[0].health_bar.max_value]

# HIDE/SHOW FUNCTIONS
func _hide_self_button() -> void:
	self_use_button.hide()
	_hide_cancel_button()

func _show_self_button() -> void:
	action_name.text = ability_type
	player_actions.hide()
	self_use_button.show()
	_show_cancel_button()

func _show_target_buttons() -> void:
	player_actions.hide()
	enemy_use_button.show()
	for e in enemy_battlers:
		e.show_select_button()
	action_name.text = attack_type
	_show_cancel_button()
		
func _hide_target_buttons() -> void:
	player_actions.hide()
	enemy_use_button.hide()
	for e in enemy_battlers:
		e.hide_select_button()
		
func _hide_player_buttons() -> void:
	player_actions.hide()
	
func _show_player_buttons() -> void:
	player_actions.show()
	
func _hide_cancel_button() -> void:
	cancel_action.hide()
	
func _show_cancel_button() -> void:
	cancel_action.show()

func _cancel_button_pressed() -> void:
	player_actions.show()
	cancel_action.hide()
	_hide_self_button()
	enemy_use_button.hide()
	for e in enemy_battlers:
		e.hide_select_button()
