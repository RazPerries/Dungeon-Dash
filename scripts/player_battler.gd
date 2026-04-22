extends Node2D

@export var stats_resource : BattlerStats

@onready var health_bar : ProgressBar = $HealthBar
@onready var turn_indicator_animation: AnimationPlayer = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player: AnimatedSprite2D = $Animations
@onready var hit_fx_animation: AnimationPlayer = $HitFX/HitFXAnimation


var current_hp : int
var defense: float = 0
var atk_mult: bool = false
var haste: bool = false
var heal_amount: int = 4

signal dead(this_battler: Node2D)
signal turn_ended
signal update_health

func _ready() -> void:
	stop_turn()
	
	current_hp = stats_resource.max_hp
	
	_update_health_bar()
	
func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp
	update_health.emit()
	
func _return_health() -> int:
	return health_bar.value
	
func start_turn() -> void:
	turn_indicator_animation.play("in_turn")
	animation_player.play("RESET")
	hit_fx_animation.play("RESET")
	defense = 0
	
func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	# animation_player.play("RESET")
	hit_fx_animation.play("RESET")
	
func start_attacking(enemy_target: Node2D, attack) -> void:
	match attack:
		"basic":
			_play_attack_anim()
			await get_tree().create_timer(0.6).timeout
			enemy_target.play_hit_fx_anim()
			await get_tree().create_timer(0.5).timeout
			enemy_target.be_damaged(_get_attack_damage())
			await get_tree().create_timer(0.1).timeout
			_stop_anim()
			turn_ended.emit()
		"triple_swipe":
			_play_attack_anim()
			await get_tree().create_timer(0.6).timeout
			enemy_target.play_hit_fx_anim()
			await get_tree().create_timer(0.5).timeout
			enemy_target.be_damaged(_get_attack_damage() * 0.3)
			await get_tree().create_timer(0.1).timeout
			enemy_target.be_damaged(_get_attack_damage() * 0.3)
			await get_tree().create_timer(0.1).timeout
			enemy_target.be_damaged(_get_attack_damage() * 0.3)
			_stop_anim()
			turn_ended.emit()
		"charge_attack":
			_play_attack_anim()
			await get_tree().create_timer(1).timeout
			enemy_target.play_hit_fx_anim()
			await get_tree().create_timer(0.5).timeout
			enemy_target.be_damaged(_get_attack_damage() * 2)
			_stop_anim()
			turn_ended.emit()
		"double_strike":
			_play_attack_anim()
			await get_tree().create_timer(0.3).timeout
			enemy_target.play_hit_fx_anim()
			await get_tree().create_timer(0.5).timeout
			enemy_target.be_damaged(_get_attack_damage() * 0.5)
			await get_tree().create_timer(0.1).timeout
			enemy_target.be_damaged(_get_attack_damage() * 0.5)
			_stop_anim()
			turn_ended.emit()
	
func start_brace() -> void:
	_play_block_anim()
	defense += 0.25
	await get_tree().create_timer(0.1).timeout
	turn_ended.emit()
	
func _play_attack_anim() -> void:
	animation_player.play("attack")
	
func _stop_anim() -> void:
	animation_player.play("RESET")
	
func _get_attack_damage() -> int:
	return stats_resource.attack_damage
	
func play_hit_fx_anim() -> void:
	hit_fx_animation.play("play")
	
func _play_block_anim() -> void:
	animation_player.play("block")
	
func be_damaged(amount: int) -> void:
	current_hp -= floor(amount * (1 - defense))
	_update_health_bar()
	if current_hp <=  0:
		current_hp =  0
		dead.emit(self)
		queue_free()
