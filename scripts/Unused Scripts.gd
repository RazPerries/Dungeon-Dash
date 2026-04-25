extends Resource
'''
A graveyard for unused scripts.


# Remains Unused for now.
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

# Remains Unused for now.
func _hide_status_effect(target) -> void:
	match target:
		"player":
			player_status_effect_label.hide()
		"enemy":
			enemy_status_effect_label.hide()

'''
