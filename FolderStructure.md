## Folder Structure

The project adopts a modular, scalable folder structure to organize scenes, scripts, and assets for a Godot-based game, ensuring maintainability and clarity.

```
bars-n-bruises/
├── assets/                                 # Raw assets for the game
│   ├── audio/                              # Audio assets
│   │   ├── music/                          # Background music (e.g., stage-01.mp3)
│   │   └── sfx/                            # Sound effects (e.g., hit-1.wav)
│   ├── fonts/                              # Font assets
│   │   ├── banner/                         # Fonts for banners
│   │   └── game/                           # Fonts for UI elements
│   ├── particles/                          # Particle effect assets
│   ├── sprites/                            # Visual sprite assets
│   │   ├── characters/                     # Character sprites
│   │   │   ├── enemy/                      # Enemy character sprites
│   │   │   │   ├── batting_girl/
│   │   │   │   └── brute_arms/
│   │   │   └── player/                     # Player character sprites
│   │   ├── props/                          # Environmental prop sprites
│   │   │   ├── banners/                    # Banner sprites
│   │   │   │   ├── cafe_bar/
│   │   │   │   ├── ethereum/
│   │   │   │   └── sushi/
│   │   │   ├── barrel/                     # Barrel sprites
│   │   │   ├── car/                        # Car sprites
│   │   │   ├── garage_door/                # Door sprites
│   │   │   ├── health/                     # Health-related sprites
│   │   │   ├── hydrant/                    # Hydrant sprites
│   │   │   ├── street/                     # Street-related sprites
│   │   │   └── tree/                       # Tree sprites
│   │   ├── tileset/                        # Tileset assets
│   │   └── ui/                             # UI sprites (e.g., health_bar.png)
├── core/                                   # Core game systems and logic
│   ├── base/                               # Base classes and utilities
│   ├── config/                             # Configuration files (e.g., settings.tres)
│   ├── state_machine/                      # State machine logic
│   │   └── character_state.gd              # Base character state script
│   └── systems/                            # Core gameplay systems
│       ├── combo_manager.gd                # Signals for combo mechanics
│       ├── damage_manager.gd               # Signals for damage calculations
│       ├── enemy_data.gd                   # Stores enemy data
│       ├── entity_manager.gd               # Signals for game entities
│       ├── options_manager.gd              # Handles game settings
│       └── stage_manager.gd                # Signals for stage and checkpoints
├── features/                               # Feature-specific scenes and scripts
│   ├── characters/                         # Character-related logic and scenes
│   │   ├── enemy/                          # Enemy character logic
│   │   │   ├── states/                     # Enemy state scripts
│   │   │   │   ├── attack_1_state.gd
│   │   │   │   ├── attack_2_state.gd
│   │   │   │   ├── attack_3_state.gd
│   │   │   │   ├── fall_state.gd
│   │   │   │   ├── fly_state.gd
│   │   │   │   ├── hurt_1_state.gd
│   │   │   │   ├── hurt_2_state.gd
│   │   │   │   ├── idle_state.gd
│   │   │   │   ├── land_1_state.gd
│   │   │   │   ├── land_2_state.gd
│   │   │   │   ├── prep_attack_state.gd
│   │   │   │   ├── wait_state.gd
│   │   │   │   ├── wakeup_state.gd
│   │   │   │   └── walk_state.gd
│   │   │   ├── types/                      # Enemy types
│   │   │   │   ├── base_enemy/
│   │   │   │   │   ├── base_enemy.gd
│   │   │   │   │   └── base_enemy.tscn
│   │   │   │   ├── boss_enemy/
│   │   │   │   │   ├── boss_enemy.gd
│   │   │   │   │   └── boss_enemy.tscn
│   │   │   │   └── girl_enemy/
│   │   │   │       ├── girl_enemy.gd
│   │   │   │       └── girl_enemy.tscn
│   │   ├── player/                         # Player character logic
│   │   │   ├── states/                     # Player state scripts
│   │   │   │   ├── attack_1_state.gd
│   │   │   │   ├── attack_2_state.gd
│   │   │   │   ├── attack_3_state.gd
│   │   │   │   ├── hurt_1_state.gd
│   │   │   │   ├── hurt_2_state.gd
│   │   │   │   ├── idle_state.gd
│   │   │   │   ├── jump_state.gd
│   │   │   │   ├── wakeup_state.gd
│   │   │   │   └── walk_state.gd
│   │   │   ├── types/                      # Player types
│   │   │   │   └── bancho_player/
│   │   │   │       ├── bancho_player.gd
│   │   │   │       └── bancho_player.tscn
│   │   │   ├── state_machine/ 
│   │   │   │   ├── state_machine.gd
│   │   │   │   └── state_machine.tscn
│   │   └── base_character.gd               # Base character script
│   ├── colliders/                          # Collider-related logic
│   │   └── damage_receiver/
│   │       ├── damage_receiver.gd
│   │       └── damage_receiver.tscn
│   ├── particles/                          # Particle effect scenes
│   │   └── spark.tscn
│   └── props/                              # Prop-related logic and scenes
│       ├── barrel/
│       │   ├── barrel.gd
│       │   └── barrel.tscn
│       ├── car/
│       │   └── car.tscn
│       ├── door/
│       │   ├── door.gd
│       │   └── door.tscn
│       ├── food/
│       │   ├── chicken_1/
│       │   │   └── chicken_1.tscn
│       │   ├── chicken_2/
│       │   │   └── chicken_2.tscn
│       │   ├── chicken_3/
│       │   │   └── chicken_3.tscn
│       ├── hydrant/
│       │   └── hydrant.tscn
│       ├── street_light/
│       │   └── street_light.tscn
│       ├── tree/
│       │   └── tree.tscn
│       ├── collectible.gd
│       └── collectible.tscn
├── stage/                                 # Game stages and levels
│   ├── base_stage/
│   │   ├── stage.gd
│   │   └── stage.tscn
│   ├── checkpoint/
│   │   ├── checkpoint.gd
│   │   └── checkpoint.tscn
│   ├── stage_01/
│   │   ├── scene/
│   │   │   └── stage_01.tscn
│   │   └── tilemap/
│   │       ├── stage_01_map.tscn
│   │       └── stage_01_tileset.tres
│   └── stage_02/
│       └── scene/
│           └── stage_02.tscn
├── ui/                                     # User interface components
│   ├── banners/
│   │   ├── banner_01/
│   │   │   ├── banner_01.gd
│   │   │   └── banner_01.tscn
│   │   ├── banner_02/
│   │   │   └── banner_02.tscn
│   │   ├── banner_03/
│   │   │   ├── banner_03.gd
│   │   │   └── banner_03.tscn
│   ├── combo_indicator/
│   │   ├── combo_indicator.gd
│   │   └── combo_indicator.tscn
│   ├── controls/
│   │   ├── label_picker/
│   │   │   ├── label_picker.gd
│   │   │   └── label_picker.tscn
│   │   ├── range_picker/
│   │   │   ├── range_picker.gd
│   │   │   └── range_picker.tscn
│   │   ├── toggle_picker/
│   │   │   ├── toggle_picker.gd
│   │   │   └── toggle_picker.tscn
│   │   ├── activable_control.gd
│   │   └── activable_control.tscn
│   ├── death_screen/
│   │   ├── death_screen.gd
│   │   └── death_screen.tscn
│   ├── game_over_screen/
│   │   ├── game_over_screen.gd
│   │   └── game_over_screen.tscn
│   ├── health_bar/
│   │   ├── health_bar.gd
│   │   └── health_bar.tscn
│   ├── options_screen/
│   │   ├── options_screen.gd
│   │   └── options_screen.tscn
│   ├── score_indicator/
│   │   ├── score_indicator.gd
│   │   └── score_indicator.tscn
│   ├── theme/
│   │   └── gui_theme.tres
│   └── ui_container/
│       ├── ui.gd
│       └── ui.tscn
├── utils/                                  # Utility scripts and scenes
│   ├── enemy_slot/
│   │   ├── enemy_slot.gd
│   │   └── enemy_slot.tscn
│   ├── flickering_texture/
│   │   ├── flickering_texture.gd
│   │   └── flickering_texture.tscn
│   ├── music_player/
│   │   ├── music_manager.gd
│   │   └── music_player.tscn
│   ├── sound_player/
│   │   ├── sound_manager.gd
│   │   └── sound_player.tscn
│   └── default_bus_layout.tres
├── world/                                  # World-related scenes and scripts
│   ├── actors_container/
│   │   └── actors_container.gd
│   ├── camera/
│   │   └── camera.gd
│   └── scene/
│       ├── world.gd
│       └── world.tscn
├── .editorconfig                           # Editor configuration
├── .gitattributes                          # Git attributes
├── .gitignore                              # Git ignore file
├── GitCommitStandards.md                   # Git commit guidelines
├── GitWorkflow.md                          # Git workflow documentation
├── LICENSE                                 # MIT License
├── README.md                               # Project documentation
└── project.godot                           # Godot project configuration
```
