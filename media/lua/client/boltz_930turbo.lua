local function info()
    dir = getDir(MOD_ID);
    loadVehicleModel("Vehicles_boltz_930turbo",
    dir.."/media/models/Vehicles_boltz_930turbo.txt",
    dir.."/media/textures/Vehicles/Vehicle_boltz_930turbo_Shell.png");

    VehicleDistributions[1].boltz_930turbo =  {
        Normal = VehicleDistributions.Normal,
        Specific = { VehicleDistributions.Groceries, VehicleDistributions.Carpenter, VehicleDistributions.Farmer, VehicleDistributions.Electrician, VehicleDistributions.Survivalist, VehicleDistributions.Clothing, VehicleDistributions.ConstructionWorker, VehicleDistributions.Painter },
    }

    ISCarMechanicsOverlay.CarList["Base.boltz_930turbo"] = {imgPrefix = "smallcar_", x=10,y=0};
    VehicleZoneDistribution.parkingstall.vehicles["Base.boltz_930turbo"] = {index = -1, spawnChance = 30};
end

Events.OnInitWorld.Add(info);
