extends Powerup

const ADD_FUEL_CAP_VALUE = 5

func apply(body):
	body.stats.max_fuel_capability += ADD_FUEL_CAP_VALUE
