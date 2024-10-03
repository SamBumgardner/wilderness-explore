class_name ExploreDisplayText extends Node

signal display_updates_done
signal encounter_initial_display_done

@export var exploreMode: ExploreMode
@export var travel_time_max: float = 1.0

var travel_time_remaining: float = travel_time_max
var traveling: bool = false
# need to have events that trigger when we receive events 
# from the ExploreMode class

func _ready() -> void:
    if exploreMode == null:
        push_error("Could not initialize display, missing exploreModeRef")

func _display_map():
    var map: ExploreMap = exploreMode.map
    var full_map: PackedStringArray = []
    for y in range(map.height):
        var map_line: PackedStringArray = []
        for x in range(map.width):
            map_line.append(map.terrains[map.tiles[y * map.width + x].terrain_idx].name)
        full_map.append(" ".join(map_line))
    var complete_map: String = "\n".join(full_map)

    print("MAP:\n%s\nEXPLORER POSITION: %s\n" % [complete_map, exploreMode.explorer.position])
    _start_travel()

func _start_travel():
    traveling = true
    travel_time_remaining = travel_time_max

func _display_encounter_started(_explorer: Explorer, encounter: Encounter):
    var display_encounter_tween = create_tween()

    var option_titles = encounter.challenge_options.map(func(x: Challenge): return x.title)
    display_encounter_tween.tween_interval(.5)
    display_encounter_tween.tween_callback(print.bind("*** AN ENCOUNTER OCURRED!!! ***"))
    display_encounter_tween.tween_interval(.2)
    display_encounter_tween.tween_callback(
        func():
            var full_display: PackedStringArray = []
            full_display.append(encounter.title)
            full_display.append(encounter.description)
            full_display.append("  OPTIONS:")
            full_display.append(", ".join(option_titles))
            full_display.append("")
            full_display.append("Resuming exploration play in 1s...")
            print("\n".join(full_display))
    )
    display_encounter_tween.tween_interval(1)
    display_encounter_tween.tween_callback(encounter_initial_display_done.emit)

func _process(delta: float):
    if traveling:
        travel_time_remaining -= delta
        if travel_time_remaining <= 0:
            traveling = false
            display_updates_done.emit()
