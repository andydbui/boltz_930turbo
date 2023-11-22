--***Adapted from KI5/bikinihorst***

BOLTZ = BOLTZ or {};

BOLTZ.Commands = BOLTZ.Commands or {};

function BOLTZ.Commands.setVehicleData(playerObj, args)
	print("BOLTZ.Commands.setVehicleData(" .. playerObj:getUsername() .. ", " .. args["_vehicleId"] .. ")");

	local vehicle = getVehicleById(args["_vehicleId"]);

	if vehicle
	then
		local part = BOLTZ:getMulePart(vehicle);

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

function BOLTZ.Commands.silentPartInstall(playerObj, args)
	local vehicle = getVehicleById(args["_vehicleId"]);
	local item = args["item"];
	local part = args["part"];

	if vehicle and part and item
	then
		print("BOLTZ.Commands.silentPartInstall(" .. playerObj:getUsername() .. ", " .. part .. ", " .. item .. ")");

		item = InventoryItemFactory.CreateItem(item);
		part = vehicle:getPartById(part);

		if item
		then
			part:setInventoryItem(item);
			vehicle:transmitPartItem(part);

			local installTable = part:getTable("install");

			if installTable and installTable.complete
			then
				VehicleUtils.callLua(installTable.complete, vehicle, part);
			end
		else
			print("no item generated");
		end
	else
		print("vehicle, part or item missing");
	end
end

Events.OnClientCommand.Add(function(moduleName, command, playerObj, args)
	if moduleName == "boltz_lib" and BOLTZ.Commands[command]
	then
		print(moduleName .. " -> " .. command .. " | " .. playerObj:getUsername());

		BOLTZ.Commands[command](playerObj, args);
	end
end);