class_name InputController extends Node

const direction_action_names: PackedStringArray = ["ui_up", "ui_down", "ui_left", "ui_right"]
const opposite_directions: PackedStringArray = ["ui_down", "ui_up", "ui_right", "ui_left"]
const direction_vectors: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var has_polled_movement_this_frame: bool = false
var direction_priority: Array[int] = []

func _process(_delta: float) -> void:
    has_polled_movement_this_frame = false

func get_movement_directions() -> Array[Vector2i]:
    _update_direction_priority()
    var result: Array[Vector2i] = []
    for idx in direction_priority:
        result.append(direction_vectors[idx])
    result.reverse()
    return result

func _update_direction_priority():
    if not has_polled_movement_this_frame:
        for i in range(direction_action_names.size()):
            var direction_action = direction_action_names[i]
            # Check if the action should be removed from the priority queue
            if not Input.is_action_pressed(direction_action) or \
                    Input.is_action_pressed(opposite_directions[i]):
                direction_priority.erase(i)
            # Check if the action should be added back to the priority queue
            elif Input.is_action_just_released(opposite_directions[i]) or \
                    Input.is_action_just_pressed(direction_action):
                direction_priority.append(i)
    has_polled_movement_this_frame = true
