class_name ExploreMode extends Node

signal explorer_moved

@export var map: ExploreMap

var input_controller: InputController
var explorer: Explorer
var take_actions: bool

func _ready():
    if map == null:
        push_error("map unset, could not initialize")
    if input_controller == null:
        input_controller = InputController.new()
        add_child(input_controller)

    var EXPLORER_STATS: PackedInt32Array = [10, 10, 10, 10]
    explorer = Explorer.new(map.start_position,
        EXPLORER_STATS, EXPLORER_STATS)

    # notify display it's good to go. 
    # don't start acting on input until you get the go-ahead
    take_actions = false

func _process(_delta: float) -> void:
    # may want to check inv. button or menu before moving.
    var move_directions: Array[Vector2i] = input_controller.get_movement_directions()
    if (take_actions):
        var bonk_move: bool = false
        for attempted_direction in move_directions:
            var destination_position = explorer.position + attempted_direction
            if map.valid_explorer_position(destination_position):
                bonk_move = false
                explorer.set_position(destination_position)
                take_actions = false
                explorer_moved.emit()
                break
                # give up control, emit event to for display to run its course.
                # can start doing stuff again after "_on_activate_explore_mode" is triggered again
            else:
                bonk_move = true
        
        if bonk_move:
            pass
            # emit event with highest priority direction + the fact the move bonked


func _on_activate_explore_mode():
    take_actions = true
