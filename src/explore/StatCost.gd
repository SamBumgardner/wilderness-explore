class_name StatCost extends Resource

@export var stat_hidden: Consts.StatHidden
@export var static_cost: int
@export var rolls: Array[int]

func _init(_static_cost: int = 0, _rolls: Array[int] = [],
        _stat_hidden: Consts.StatHidden = Consts.StatHidden.SHOW) -> void:
    static_cost = _static_cost
    rolls = _rolls
    stat_hidden = _stat_hidden