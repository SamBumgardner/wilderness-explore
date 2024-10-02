class_name ExploreDisplayText extends Node

signal display_updates_done

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

func _process(delta:float):
    if traveling:
        travel_time_remaining -= delta
        if travel_time_remaining <= 0:
            traveling = false
            display_updates_done.emit()
