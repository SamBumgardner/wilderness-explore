extends Node2D

@onready var explore_mode: ExploreMode = $ExploreMode
@onready var explore_display_text: ExploreDisplayText = $ExploreDisplayText

func _ready() -> void:
    explore_mode.explorer_moved.connect(explore_display_text._display_map)
    explore_display_text.display_updates_done.connect(explore_mode._on_moving_finished)

    explore_mode.explorer_encounter.connect(explore_display_text._display_encounter_started)
    explore_display_text.encounter_initial_display_done.connect(explore_mode._on_encounter_finished)

    explore_display_text._display_map()
