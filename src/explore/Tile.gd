class_name Tile extends RefCounted

var terrain_idx: int
var encounter: Encounter
var has_been_visited: bool

func _init(_terrain_idx: int, _encounter: Encounter) -> void:
    terrain_idx = _terrain_idx
    encounter = _encounter
    has_been_visited = false