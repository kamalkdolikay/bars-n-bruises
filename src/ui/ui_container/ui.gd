class_name UI
extends CanvasLayer

const DEATH_SCREEN_PREFAB := preload("res://src/ui/death_screen/death_screen.tscn")
const OPTIONS_SCREEN_PREFAB := preload("res://src/ui/options_screen/options_screen.tscn")
const GAME_OVER_PREFAB := preload("res://src/ui/game_over_screen/game_over_screen.tscn")

@onready var player_health_bar: HealthBar = $UIContainer/PlayerHealthBar
@onready var enemy_health_bar: HealthBar = $UIContainer/EnemyHealthBar
@onready var player_avatar: Sprite2D = $UIContainer/PlayerAvatar
@onready var enemy_avatar: Sprite2D = $UIContainer/EnemyAvatar
@onready var enemy_avatar_2: Sprite2D = $UIContainer/EnemyAvatar2
@onready var combo_indicator: ComboIndicator = $UIContainer/ComboIndicator
@onready var score_indicator: ScoreIndicator = $UIContainer/ScoreIndicator
@onready var go_indicator: FlickeringTextureRect = $UIContainer/GoIndicator


@export var duration_healthbar_visible: int

var time_since_healthbar_visible := Time.get_ticks_msec()
var option_screen: OptionsScreen = null
var death_screen: DeathScreen = null
var game_over_screen: GameOverScreen = null

const avatar_map: Dictionary = {
	BaseCharacter.Type.GIRL: preload("res://src/assets/sprites/characters/enemy/batting_girl/BattingGirl_Idle-Sheet.png"),
	BaseCharacter.Type.BOSS: preload("res://src/assets/sprites/characters/enemy/brute_arms/BruteArm_Idle.png")
}

func _init() -> void:
	DamageManager.health_change.connect(on_character_health_change)
	StageManager.checkpoint_complete.connect(on_checkpoint_complete)

func _ready() -> void:
	enemy_avatar.visible = false
	enemy_avatar_2.visible = false
	enemy_health_bar.visible = false
	combo_indicator.combo_reset.connect(on_combo_reset)

func _process(_delta: float) -> void:
	if enemy_health_bar.visible and (Time.get_ticks_msec() - time_since_healthbar_visible > duration_healthbar_visible):
		enemy_avatar.visible = false
		enemy_avatar_2.visible = false
		enemy_health_bar.visible = false
	handle_input()

func on_character_health_change(type: BaseCharacter.Type, current_health: int, max_health: int) -> void:
	if type == BaseCharacter.Type.PLAYER:
		player_health_bar.refresh(current_health, max_health)
		if current_health == 0 and death_screen == null:
			death_screen = DEATH_SCREEN_PREFAB.instantiate()
			death_screen.game_over.connect(on_game_over)
			add_child(death_screen)
	else:
		time_since_healthbar_visible = Time.get_ticks_msec()
		if type == BaseCharacter.Type.BOSS:
			enemy_avatar.visible = false
			enemy_avatar_2.visible = true
		elif type == BaseCharacter.Type.GIRL:
			enemy_avatar_2.visible = false
			enemy_avatar.visible = true
		enemy_health_bar.refresh(current_health, max_health)
		enemy_health_bar.visible = true

func on_combo_reset(points: int) -> void:
	score_indicator.add_combo(points)

func on_checkpoint_complete() -> void:
	go_indicator.start_flickering()

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if option_screen == null:
			option_screen = OPTIONS_SCREEN_PREFAB.instantiate()
			option_screen.exit.connect(unpause)
			add_child(option_screen)
			get_tree().paused = true
		else:
			unpause()

func unpause() -> void:
	option_screen.queue_free()
	get_tree().paused = false

func on_game_over() -> void:
	if game_over_screen == null:
		game_over_screen = GAME_OVER_PREFAB.instantiate()
		game_over_screen.set_score(score_indicator.real_score)
		add_child(game_over_screen)
