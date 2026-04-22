extends Node
class_name SkillsAbilities

# Player Abilities
# Arrays are [QTE Time, Dmg % of ATK]

var player_attack_triple_strike: Array = [[5, 0.75], [5, 0.75], [5, 0.75]]

var player_attack_charge: Array = [[1.5], [1.5,10]]

var player_double_strike: Array = [[5, 0.75],[5, 0.75]]

var player_buff_haste_up: int = 3

var player_buff_atk_up: int = 3

var player_buff_heal: int = 2

# Enemy Abilities (Attacks Will Have Parry Indicators)

# Bandit
var bandit_attack_charge: Array = [[1.5], [1.5,10]]

var bandit_attack_triple: Array = [[5, 0.75], [5, 0.75], [5, 0.75]]

var bandit_attack_two_offbeat: Array = [[5, 0.75],[5, 0.75]]

var bandit_buff_atk_up: int = 4

var bandit_buff_heal: int = 5

# Sabotages

var speed_up: float = 0.15

var size_down: float = 0.15

var punishing_misses: bool = false
