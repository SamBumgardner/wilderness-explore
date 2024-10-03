class_name ExploreMap extends Resource

@export var name: String
@export var start_position: Vector2i

@export var terrains: Array[Terrain]
@export var static_encounters: Dictionary

## Size should always be square, probably.
## Values should be the terrain index for that tile
@export var tile_gen: PackedInt32Array:
    set(value):
        tile_gen = value
        _generate_tiles()
        
@export var width: int
@export var height: int
var tiles: Array[Tile]

func _generate_tiles() -> void:
    for i in range(tile_gen.size()):
        var terrain_idx = tile_gen[i]
        var encounter = static_encounters.get(i, null)
        tiles.append(Tile.new(terrain_idx, encounter))

func valid_explorer_position(position: Vector2i):
    return position.x >= 0 and position.y >= 0 \
        and position.x < width and position.y < height \
        and (width * position.y + position.x) < tiles.size()
    # Want to do more involved checks in the future - like is the tile valid 
    # for our character to stand on?

func get_tile_at(position: Vector2i) -> Tile:
    var result: Tile
    var target_idx: int = width * position.y + position.x

    if target_idx >= tiles.size():
        push_warning("attempted to get invalid tile index %s" % position)
    else:
        result = tiles[target_idx]

    return result
