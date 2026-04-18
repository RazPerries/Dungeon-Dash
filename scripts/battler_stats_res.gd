extends Resource
class_name BattlerStats

enum BattlerType {
	PLAYER,
	ENEMY
}
@export var type : BattlerType
@export var max_hp : int
@export var defense : int #
@export var attack_damage : int # The basic attack damage
@export var turn_speed : int # Determines turn order (Lower = Faster)
