GOD = GOD or {};
GOD.Shield = GOD.Shield or {};
GOD.Shield.Commands = GOD.Shield.Commands or {};

function GOD.Shield.Commands.setPartModData(player, args)
    local vehicle = getVehicleById(args.vehicle);

    if vehicle and args.data
    then
        local part = vehicle:getPartById(args.part);

        if part
        then
            local modData = part:getModData();

            for k, v in pairs(args.data)
            do
                modData[k] = v;
            end

            vehicle:transmitPartModData(part);
        end
    end
end

Events.OnClientCommand.Add(function(moduleName, command, playerObj, args)
    if moduleName == "GOD_shield" and GOD.Shield.Commands[command]
    then
        GOD.Shield.Commands[command](player, args);
    end
end);