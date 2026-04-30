# Dungeon Dash
A turn-based game that focuses on player engagement by introducing mechanics that go beyond turn-based combat, such as interacting to enemy attacks with parrying, evading, or blocking. It also introduces a method for enemies to engage with the player’s attacks. 

## Turn-Based Combat
As a turn-based game, the enemy will wait until the player plays their turn and the player will wait until the enemy plays theirs. The order in which a character starts before the other depends on their speed.

## No Movement 
The player will not be given the option to move because of time constraints. This game will focus solely on the combat system that makes it different and more engaging than traditional turn-based games. 

## Player Actions
### Enemy Attack Interactions
The player can directly impact enemy attacks by Blocking, Evading, & Parrying. These interactions allow the player to mitigate or avoid enemy attacks.
- **Blocking** reduces incoming damage from attacks by 20%. 
- **Evading** provides active frames where the player will not take any damage from attacks. 
- **Parrying** is similar to evading. However, it provides less active frames. If the player successfully parries all incoming attacks from the enemy’s turn, the player will get a free turn, independent of the players’ own turn, against the enemy to play whatever they want.

### Basic Attack 
Simple attack that deals guaranteed damage. It does not require any quick-time events and is not affected by attack sabotages or stances.  

### Skills
Skills made by the player have quick time events (QTE). These are to allow the enemy to directly influence the player’s attacks. 
- These QTEs are button presses timed at the right moment to utilize the skill to its full potential. Missing QTEs, however, can make the skill less potent by making it deal less damage or possible to miss, along with being susceptible to the enemy’s stance.
- More complex attacks or abilities require the player to hit quick-time events. The harder the QTEs, the bigger impact it will have. 

### Brace 
Skips the player's turn but reduces all incoming damage by 20% (Can stack with blocking). 

## Enemy Characteristics 
### Attack Sabotages 
The way the enemy can directly influence the player’s skills. Attack sabotages can affect how the QTEs of the player are. These include increasing the speed they appear, decreasing the size of them, or adding additional presses into them. 
- Sabotages can stack, meaning multiple size downs will make the QTEs even smaller, or a size down and speed up makes them small and faster. 
- Sabotages are limited per enemy, and certain sabotages are blacklisted for certain enemies, so stronger sabotages are given to stronger enemies. 
- Sabotages: Speed ups, Size Downs

### Enemy Stances 
Enemy Stances are how the enemy will punish the player for missing their QTEs. So far, there are 3 planned stances. 
- **Blocking:** The attack will simply even deal less damage. 
- **Evading:** The attack has a higher chance to miss. 
- **Parrying:** The enemy will interrupt your attack and counterattack you. This is planned to only be applied to the boss of the game (The only stance currently added). 
