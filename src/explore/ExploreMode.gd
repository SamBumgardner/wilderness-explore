class_name ExploreMode extends Node

enum State {
    PAUSED,
    IDLE,
    MOVING,
    ARRIVAL,
    ENCOUNTER,
}

const STATIC_ENCOUNTER_RISK_REDUCTION = .5

signal explorer_moved
signal explorer_encounter(explorer: Explorer, encounter: Encounter)

@export var map: ExploreMap
@export var rand_event_risk: float = 0.0

var input_controller: InputController
var explorer: Explorer
var state: State

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
    state = State.PAUSED

func _process(_delta: float) -> void:
    # may want to check inv. button or menu before moving.
    var move_directions: Array[Vector2i] = input_controller.get_movement_directions()
    if state == State.IDLE:
        _attempt_move(move_directions)
    elif state == State.ARRIVAL:
        _arrival_encounter_checks()

        
func _attempt_move(move_directions: Array[Vector2i]) -> void:
    var move_successful: bool = false
    for attempted_direction in move_directions:
        var destination_position: Vector2i = explorer.position + attempted_direction
        if map.valid_explorer_position(destination_position):
            explorer.set_position(destination_position)
            move_successful = true
            break ;

    if move_successful:
        state = State.MOVING
        explorer_moved.emit()
    elif not move_successful and move_directions.size() >= 1:
        # emit event with highest priority direction + the fact the move bonked
        pass

func _arrival_encounter_checks() -> void:
    var arrival_tile: Tile = map.get_tile_at(explorer.position)
    rand_event_risk += map.terrains[arrival_tile.terrain_idx].threat_value
    
    var encounter: Encounter = _static_encounter_check(arrival_tile)
    if encounter == null:
        encounter = _random_encounter_check(arrival_tile, map)
    
    if encounter != null:
        state = State.ENCOUNTER
        explorer_encounter.emit(explorer, encounter)
    else:
        state = State.IDLE

func _static_encounter_check(arrival_tile: Tile) -> Encounter:
    var result: Encounter
    # TODO: Need to handle this in a more nuanced way - static events showing on map would
    # be ideal. Maybe use "has visited" property of tile + whether encounter has been defeated or
    # not. Or maybe remove encounter from tile when it's beaten?
    result = arrival_tile.encounter
    rand_event_risk *= STATIC_ENCOUNTER_RISK_REDUCTION

    return result

func _random_encounter_check(arrival_tile: Tile, current_map: ExploreMap) -> Encounter:
    var result: Encounter

    # do some evaluation of the rand_event_risk to decide if we have an encounter.
    # need to check against encounter tables in the map + tile coordinates and terrain.
    if result != null:
        rand_event_risk = 0.0
    
    return result

func _on_moving_finished():
    state = State.ARRIVAL

func _on_encounter_finished():
    state = State.IDLE
