extends Node

# Player Abilities
# Arrays are [QTE Time, Dmg % of ATK]

const player_attack_triple_strike: Array = [[0, 0.75], [1, 0.75], [2, 0.75]]

const player_attack_charge: Array = [[1,1.5]]

const player_double_strike: Array = [[0, 0.75],[1, 0.75]]

const player_buff_haste_up_max: int = 3

const player_buff_atk_up_max: int = 3

const player_buff_heal_max: int = 2

# Enemy Abilities (Attacks Will Have Parry Indicators)

# Bandit
const bandit_attack_charge: Array = [2, 1.25]

const bandit_attack_triple: Array = [[1, 0.50], [2, 0.50], [3, 0.50]]

const bandit_attack_two_offbeat: Array = [[1.5, 0.75],[2, 0.75]]

const bandit_buff_atk_up_max: int = 4

const bandit_buff_heal_max: int = 5
