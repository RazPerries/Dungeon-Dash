extends Node

# General stuff

const qte_speed: float = 2

const parry_iframes: float = 0.1

const evade_iframes: float = 0.25

# Player Abilities
# Arrays are [QTE Time, Dmg % of ATK]

const player_attack_triple_strike: Array = [[0, 0.75], [1, 0.75], [2, 0.75]]

const player_attack_charge: Array = [[1,1.5]]

const player_double_strike: Array = [[0, 0.75],[1, 0.75]]

const player_buff_haste_up_max: int = 3

const player_buff_atk_up_max: int = 3

const player_buff_heal_max: int = 2

const player_buff_heal_amount: int = 200

# Enemy Abilities (Attacks are parriable)

# Bandit
const bandit_attack_charge: Array = [[2, 1.25]]

const bandit_attack_triple: Array = [[1, 0.50], [2, 0.50], [3, 0.50]]

const bandit_attack_two_offbeat: Array = [[1.5, 0.75],[2, 0.75]]

const bandit_buff_atk_up_max: int = 4

const bandit_buff_heal_max: int = 5

# Parry Chance (%)
const bandit_parry_chance: float = 50.0

# Enemy Sabotages

const sabotage_player_attack_speed_up = ["Player Speed Up", 1.0]

const sabotage_enemy_attack_speed_up = ["Enemy Speed Up", 1.0]

const sabotage_enemy_size_down = ["Enemy Size Down", 0.85]

const sabotage_player_size_down = ["Player Size Down", 0.85]
