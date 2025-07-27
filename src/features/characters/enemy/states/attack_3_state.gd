class_name EnemyAttack3
extends CharacterState

@export var enemy: BaseEnemy
@onready var damage_emitter: Area2D = $"../../DamageEmitter"

enum LocalState { START, END }

var attack_state := {
	LocalState.START: "attack3_start",
	LocalState.END: "attack3_finish",
}
var finish_attack: bool = false

func enter() -> void:
	enemy.play_animation(attack_state[LocalState.START])
	
func update(_delta: float) -> void:
	if finish_attack:
		damage_emitter.monitoring = true
		enemy.play_animation(attack_state[LocalState.END])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == attack_state[LocalState.START]:
		finish_attack = true
	elif anim_name == attack_state[LocalState.END]:
		transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.stop_animation()
	damage_emitter.monitoring = false
	finish_attack = false
