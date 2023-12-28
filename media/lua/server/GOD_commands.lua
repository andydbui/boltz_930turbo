GOD = GOD or {};

GOD.Commands = GOD.Commands or {};

function GOD.Commands.setVehicleData(playerObj, args)
    print("GOD.Commands.setVehicleData(" .. playerObj:getUsername() .. ", " .. args["_vehicleId"] .. ")");

    local vehicle = getVehicleById(args["_vehicleId"]);

    if vehicle
    then
        local part = GOD:getMulePart(vehicle);

        if part
        then
            print("setting mod data");

            local modData = part:getModData();

            for k, v in pairs(args)
            do
                if k ~= "_vehicleId" and k ~= "contentAmount"
                then
                    print("- setting " .. tostring(k) .. " = " .. tostring(v));
                    modData[k] = v;
                end
            end

            vehicle:transmitPartModData(part);
        else
            print("unable to find mule part");
        end
    else
        print("unable to find vehicle");
    end
end
