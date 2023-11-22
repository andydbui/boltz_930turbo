--***Adapted from KI5/bikinihorst***

BOLTZ = BOLTZ or {};
BOLTZ.Armor = BOLTZ.Armor or {};
BOLTZ.Armor.Commands = BOLTZ.Armor.Commands or {};

function BOLTZ.Armor.Commands.setPartModData(playerObj, args)

	local vehicle = getVehicleById(args.vehicle);

	if vehicle and args.data
	then
		local part = vehicle:getPartById(args.part);

		if part
		then
			local modData = part:getModData();

			for key, value in pairs(args.data)
			do
				modData[key] = value;
			end

			vehicle:transmitPartModData(part);
		end
	end
end


Events.OnClientCommand.Add(function(moduleName, command, playerObj, args)
	if moduleName == "BOLTZ_armor" and BOLTZ.Armor.Commands[command]
	then
		BOLTZ.Armor.Commands[command](playerObj, args);
	end
end);