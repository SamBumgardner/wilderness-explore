class_name ExploreMap extends Resource

@export var name: String
@export var start_position: Vector2i

@export var terrains: Array[Terrain]
@export var static_encounters: Dictionary

## Size should always be square, probably.
## Values should be the terrain index for that tile
@export var tile_gen: PackedInt32Array = [0, 0, 0, 0]
@export var width: int
@export var height: int
var tiles: Array[Tile]

func _init() -> void:
    for i in range(tile_gen.size()):
        var terrain_idx = tile_gen[i]
        var encounter = static_encounters.get(i, null)
        tiles.append(Tile.new(terrain_idx, encounter))

func valid_explorer_position(position: Vector2i):
    return position.x >= 0 and position.y >= 0 \
        and (width * position.y + position.x) < tiles.size()
    # Want to do more involved checks in the future - like is the tile valid 
    # for our character to stand on?
