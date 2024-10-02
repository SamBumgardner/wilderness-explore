class_name ExploreMap extends Resource

@export var name: String

@export var terrains: Array[Terrain]
@export var static_encounters: Dictionary

## Size should always be square, probably.
## Values should be the terrain index for that tile
@export var tile_gen: PackedInt32Array = [0, 0, 0, 0]
var tiles: Array[Tile]

func _init() -> void:
    for i in range(tile_gen.size()):
        var terrain_idx = tile_gen[i]
        var encounter = static_encounters.get(i, null)
        tiles.append(Tile.new(terrain_idx, encounter))
