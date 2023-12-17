if VehicleZoneDistribution then

	VehicleZoneDistribution.parkingstall.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 1.75};

	VehicleZoneDistribution.medium.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 7};

	VehicleZoneDistribution.good.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 15};
	
	VehicleZoneDistribution.trafficjamw.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 2};

	VehicleZoneDistribution.newdealer = VehicleZoneDistribution.newdealer or {};
	VehicleZoneDistribution.newdealer.vehicles = VehicleZoneDistribution.newdealer.vehicles or {};
	
	VehicleZoneDistribution.newdealer.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 20};
	
	VehicleZoneDistribution.specialdealer = VehicleZoneDistribution.specialdealer or {};
	VehicleZoneDistribution.specialdealer.vehicles = VehicleZoneDistribution.specialdealer.vehicles or {};

	VehicleZoneDistribution.useddealer = VehicleZoneDistribution.useddealer or {};
	VehicleZoneDistribution.useddealer.vehicles = VehicleZoneDistribution.useddealer.vehicles or {};
	
	VehicleZoneDistribution.useddealer.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 5};
end