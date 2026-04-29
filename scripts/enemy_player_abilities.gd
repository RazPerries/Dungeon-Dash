extends Node

# General stuff

# Speed of the QTE
const qte_speed: float = 2

# Duration of parrying
const parry_iframes: float = 0.1

# Duration of evading
const evade_iframes: float = 0.25

# The chance that the bandit will parry a mistimed attack
const bandit_parry_chance: float = 50.0

# Player Attacks

# Player Attack Format:
# name_of_attack
#	attack name
#	damage percentage (%) of the player's attack
#	attack seqeuence determines position of QTE during attack
const player_attacks = {
	"basic_attack": {
		"name": "Basic Attack",
		"damage_percentage": [0.80],
	},
	"charge_attack":{
		"name": "Charge Attack",
		"damage_percentage": [1.40],
		"attack_sequence": [1],
	},
	"double_strike_attack":{
		"name": "Double Strike Attack",
		"damage_percentage": [0.60, 0.70],
		"attack_sequence": [0, 1],
	},
	"triple_strike_attack":{
		"name": "Triple Strike Attack",
		"damage_percentage": [0.40, 0.50, 0.60],
		"attack_sequence": [0, 1, 2],
	},
}

const player_abilities = {
	"heal": {
		"name": "Heal",
		"heal_amount": [200],
		"max_uses":2,
	},
	"attack_up":{
		"name": "Attack Up",
		"attack_increase_percentage": [150],
		"duration": 3,
	},
}

# Bandit

const bandit_attacks = {
	"charge_attack":{
		"name": "Charge Attack",
		"damage_percentage": [0.50, 0.75, 0.75],
		"attack_sequence": [1, 2.5, 3],
	},
	"two_offbeat_attack":{
		"name": "Two Offbeat Attack",
		"damage_percentage": [0.60, 0.60],
		"attack_sequence": [0, 1],
	},
	"triple_strike_attack":{
		"name": "Triple Strike Attack",
		"damage_percentage": [0.50, 0.50, 0.50],
		"attack_sequence": [0, 1, 2],
	},
	"four_offbeat_attack":{
		"name": "Quadruple Offbeat Attack",
		"damage_percentage": [0.30, 0.30, 0.30, 0.30],
		"attack_sequence": [1.5, 2.5, 4, 4.5],
	},
	"three_row_attack":{
		"name": "Three Row Attack",
		"damage_percentage": [0.40, 0.40, 0.40],
		"attack_sequence": [0.5, 1, 1.5],
	},
}

const bandit_abilities = {
	"heal": {
		"name": "Heal",
		"heal_amount": [250],
		"max_uses":2,
	},
	"attack_up":{
		"name": "Attack Up",
		"attack_increase_percentage": [120],
		"duration": 2,
	},
}

# Enemy Sabotages

const sabotages = {
	"player_attack_speed_up": {
		"name": "Player Attack Speed Up",
		"speed_up": 1.0,
	},
	"enemy_attack_speed_up": {
		"name": "Enemy Attack Speed Up",
		"speed_up": 1.0,
	},
	
	"player_size_down": {
		"name": "Player Size Down",
		"size_down_percentage": 0.85,
	},
	"enemy_size_down": {
		"name": "Enemy Size Down",
		"size_down_percentage": 0.85,
	}
}

const sabotage_player_attack_speed_up = ["Player Speed Up", 1.0]
const sabotage_enemy_attack_speed_up = ["Enemy Speed Up", 1.0]
const sabotage_enemy_size_down = ["Enemy Size Down", 0.85]
const sabotage_player_size_down = ["Player Size Down", 0.85]
