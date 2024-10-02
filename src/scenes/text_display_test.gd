extends Node2D

@onready var explore_mode: ExploreMode = $ExploreMode
@onready var explore_display_text: ExploreDisplayText = $ExploreDisplayText

func _ready() -> void:
    explore_mode.explorer_moved.connect(explore_display_text._display_map)
    explore_display_text.display_updates_done.connect(explore_mode._on_activate_explore_mode)
    explore_display_text._display_map()
