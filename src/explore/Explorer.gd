class_name Explorer extends RefCounted

signal stat_update(stat_idx, previous, new)

var position: Vector2i
var stats_max: PackedInt32Array
var stats: PackedInt32Array

func _init(_position: Vector2i, _stats_max: PackedInt32Array,
        _stats: PackedInt32Array) -> void:
    _validate_stats_array(_stats_max)
    _validate_stats_array(_stats)
    position = _position
    stats_max = _stats_max.duplicate()
    stats = _stats.duplicate()

func change_stat(stat_idx: Consts.StatIdx, amount: int) -> int:
    var old_value = stats[stat_idx]
    stats[stat_idx] = clamp(old_value + amount, 0, stats_max[stat_idx])

    stat_update.emit(stat_idx, old_value, stats[stat_idx])
    return stats[stat_idx]

func set_stat(stat_idx: Consts.StatIdx, new_value: int) -> int:
    var old_value = stats[stat_idx]
    stats[stat_idx] = clamp(new_value, 0, stats_max[stat_idx])

    stat_update.emit(stat_idx, old_value, stats[stat_idx])
    return stats[stat_idx]

func set_coordinates(new_x: int, new_y: int) -> Vector2i:
    position.x = new_x
    position.y = new_y
    return position

func set_position(new_position: Vector2i) -> Vector2i:
    position.x = new_position.x
    position.y = new_position.y
    return position

func _validate_stats_array(_stats: PackedInt32Array) -> void:
    if (_stats.size() != Consts.StatIdx.size()):
        push_error("ERROR: player %s was given invalid stats array %s" % self, _stats)