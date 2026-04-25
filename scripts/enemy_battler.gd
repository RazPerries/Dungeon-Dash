extends Node2D

@export var stats_resource : BattlerStats

@onready var health_bar : ProgressBar = $HealthBar
@onready var turn_indicator_animation: AnimationPlayer = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player: AnimatedSprite2D = $Animations
@onready var select_target_button: Button = $SelectTargetButton
@onready var hit_fx_animation: AnimationPlayer = $HitFX2/HitFXAnimation

var current_hp : int

signal be_selected(this_target: Node2D)
signal dead(this_enemy: Node2D)
signal deal_damage(damage: int)
signal update_health

func _ready() -> void:
	select_target_button.hide()
	stop_turn()
	
	current_hp = stats_resource.max_hp
	
	select_target_button.pressed.connect(_on_select_button_pressed)
	
	_update_health_bar()
	
func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp
	update_health.emit()
	
func start_turn() -> void:
	turn_indicator_animation.play("in_turn")
	#_play_attack_anim()
	#await get_tree().create_timer(0.2).timeout
	deal_damage.emit(_get_attack_damage())
 
func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	animation_player.play("RESET")
	hit_fx_animation.play("RESET")
	
func start_attacking(player: Node2D, attack) -> void:
	_play_attack_anim()
	await get_tree().create_timer(0.2).timeout
	player.play_hit_fx_anim()
	await get_tree().create_timer(0.2).timeout
	player.be_damaged(_get_attack_damage() * attack)
	_stop_anim()

func show_select_button() -> void:
	select_target_button.show()
	
func hide_select_button() -> void:
	select_target_button.hide()
	
func _on_select_button_pressed() -> void:
	be_selected.emit(self)
	
func _play_attack_anim() -> void:
	animation_player.play("attack")
	
func _get_attack_damage() -> int:
	return stats_resource.attack_damage
	
func play_hit_fx_anim() -> void:
	hit_fx_animation.play("RESET")
	hit_fx_animation.play("play")
	
func be_damaged(amount: int) -> void:
	current_hp -= amount
	_update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()
		
func _stop_anim() -> void:
	animation_player.play("RESET")
	
