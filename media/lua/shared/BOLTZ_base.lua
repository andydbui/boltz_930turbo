--***Adapted from KI5/bikinihorst***

BOLTZ = BOLTZ or {};

-- create vehicle from config --

BOLTZ.loadedParts = BOLTZ.loadedParts or {};
BOLTZ.partDefaultsDebug = false;
BOLTZ.modDataDebug = false;

function BOLTZ:createVehicleConfig(rootNS)
    for i, node in ipairs({"Init", "Create", "InstallComplete", "UninstallComplete", "CheckEngine", "CheckOperate", "ContainerAccess", "InstallTest", "UninstallTest", "Update", "Use"})
    do
        if not rootNS[node]
        then
            rootNS[node] = {};
        end
    end

    if rootNS.parts
    then
		for partNS, partConfig in pairs(rootNS.parts)
		do
			for partName, partVariants in pairs(partConfig)
			do
				if type(rootNS.parts[partNS]) == "table"
				then
					if not rootNS[partNS]
					then
						rootNS[partNS] = function(vehicle, part)
							part = vehicle:getPartById(partName);
							local item = part:getInventoryItem();

							if item
							then
								for varModelName, varItem in pairs(partVariants)
								do
									part:setModelVisible(varModelName, item:getType() == varItem);
								end
							end
						end;
					end

					if not rootNS.Create[partNS]
					then
						rootNS.Create[partNS] = function(vehicle, part)
							part:setInventoryItem(nil);
							rootNS[partNS](vehicle, part, nil);
							vehicle:doDamageOverlay();
						end
					end

					for i, partFn in ipairs({"Init", "InstallComplete", "UninstallComplete"})
					do
						if not rootNS[partFn][partNS]
						then
							rootNS[partFn][partNS] = function(vehicle, part)
								if partFn == "Init"
								then
									BOLTZ:checkDefaultParts(vehicle, part, rootNS.parts[partNS]);

									local vName = vehicle:getScript():getName();

									if not BOLTZ.loadedParts[vName]
									then
										BOLTZ.loadedParts[vName] = {
											rootNS = rootNS,
											parts = {}
										}
									end

									if not BOLTZ.loadedParts[vName].parts[partNS]
									then
										BOLTZ.loadedParts[vName].parts[partNS] = true;
									end
								end

								rootNS[partNS](vehicle, part);
								vehicle:doDamageOverlay();
							end
						end
					end
				end
			end
		end
	end
end

-- process default parts

function BOLTZ:checkDefaultParts(vehicle, part, partConfig)
	local partId = part:getId();
	local modData = BOLTZ:getModData(vehicle);
	local default = partConfig["default"];

	if not modData["defaultPartSet_" .. partId] and BOLTZ:partIsMissing(part)
	then
		if part:getTable("install")
		then
			local item = nil;

			if default
			then
				local possibilities = part:getItemType();

				if default == "first"
				then
					item = possibilities:get(0);
				elseif default == "random"
				then
					item = possibilities:get(ZombRandBetween(0, possibilities:size()));
				elseif default == "trve_random"
				then
					if ZombRandBetween(1, 100) >= tonumber(partConfig["noPartChance"] or 50)
					then
						item = possibilities:get(ZombRandBetween(0, possibilities:size()));
					end
				else
					item = default;
				end

                if BOLTZ.partDefaultsDebug and item
                then
                    print("BOLTZ:checkDefaultParts() -> would install item " .. tostring(item) .. " in slot " .. partId);
                end

				if not BOLTZ.partDefaultsDebug and item
				then
					BOLTZ:silentPartInstall(part, item);
				end
			end

			if not BOLTZ.partDefaultsDebug
			then
				BOLTZ:saveModData(vehicle, {
					["defaultPartSet_" .. partId] = "true"
				});
			end

			--if KI5.partDefaultsDebug and KI5:partIsMissing(part)
			--then
				--print("KI5:checkDefaultParts() -> part " .. partId .. " still missing");
			--end
		end
	end
end


-- check if part exists

function BOLTZ:partIsMissing(part)
	return part:getItemType() and not part:getItemType():isEmpty() and not part:getInventoryItem();
end


-- silently install item in part slot

function BOLTZ:silentPartInstall(part, itemId)
    if BOLTZ.partDefaultsDebug
	then
        print("BOLTZ:silentPartInstall() -> silently installing " .. itemId .. " for " .. part:getId());
    end

	BOLTZ:sendClientCommand("boltz_lib", "silentPartInstall", {
		part = part:getId(),
		item = itemId
	}, part:getVehicle());
end


-- set container amounts (tires, gas tank, ...)

function BOLTZ:setContainerAmount(part, amount)
	BOLTZ:sendClientCommand("vehicle", "setContainerContentAmount", {
		vehicle = part:getVehicle():getId(),
		part = part:getId(),
		amount = amount
	});
end


-- replace old tire type with new one

function BOLTZ:checkLegacyTires(vehicle)
	for i = 0, vehicle:getPartCount() -1
	do
		local part = vehicle:getPartByIndex(i);

		if not BOLTZ:partIsMissing(part)
		then
			local inventoryItem = part:getInventoryItem();

			if inventoryItem and inventoryItem:getFullType() == "Base.V100Tire2"
			then
                if BOLTZ.partDefaultsDebug
                then
                    print("BOLTZ:checkLegacyTires() -> replacing " .. inventoryItem:getFullType() .. " on vehicle " .. tostring(vehicle:getSqlId()));
                end

				BOLTZ:silentPartInstall(part, "Base.V101Tire2");
				BOLTZ:setContainerAmount(part, 35);
			end
		end
	end
end


-- moddata fuckery because vehicle moddata is currently wonky

BOLTZ.muleParts = BOLTZ.muleParts or {
	"M101A3Trunk",
	"GloveBox",
	"TruckBed",
	"TrailerTrunk",
	"TruckBedOpen",
	"Engine",
};

function BOLTZ:getMulePart(vehicle)
	if vehicle
	then
		for i, partId in ipairs(BOLTZ.muleParts)
		do
			local part = vehicle:getPartById(partId);

			if part
			then
				return part;
			end
		end

        if BOLTZ.modDataDebug
        then
            print("BOLTZ:getMulePart() -> mule part not found");
        end
	elseif BOLTZ.modDataDebug
    then
		print("BOLTZ:getMulePart() -> vehicle not found");
	end

	return nil;
end

function BOLTZ:getModData(vehicle)
	local part = BOLTZ:getMulePart(vehicle);

	if part
	then
		return part:getModData();
	else
        if BOLTZ.modDataDebug
        then
            print("BOLTZ:getModData() -> data mule part NOT found");
        end

		return {};
	end
end

-- boltz_lib?
function BOLTZ:saveModData(vehicle, data)
	BOLTZ:sendClientCommand("boltz_lib", "setVehicleData", data, vehicle);
end


-- shortcut for client command

function BOLTZ:sendClientCommand(moduleName, methodName, args, vehicle)
	if vehicle
	then
		args["_vehicleId"] = vehicle:getId();
	end

	sendClientCommand(getPlayer(), moduleName, methodName, args);
end
