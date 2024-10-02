class_name ExploreDisplayText extends Node

signal display_updates_done

@export var exploreMode: ExploreMode

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
    "\n".join(full_map)

    print("MAP:\n%s" % full_map)
    display_updates_done.emit()
