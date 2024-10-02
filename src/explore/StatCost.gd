class_name StatCost extends Resource

var stat_hidden: Consts.StatHidden
var static_cost: int
var rolls: Array[int]

func _init(_static_cost: int = 0, _rolls: Array[int] = [],
        _stat_hidden: Consts.StatHidden = Consts.StatHidden.SHOW) -> void:
    static_cost = _static_cost
    rolls = _rolls
    stat_hidden = _stat_hidden