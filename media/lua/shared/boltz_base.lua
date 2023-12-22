boltz = boltz or {};

boltz.loadedParts = boltz.loadedParts or {};
boltz.partDefaultDebug = false;
boltz.modDataDebug = false;


function boltz:createVehicleConfig(rootNS)
	for i, node in ipairs({"Init", "Create", "InstallComplete", "UninstallComplete", "CheckEngine", "ContainerAccess", "InstallTest", "UninstallTest", "Update", "Use"})
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
                            local item = part:getInventoryItem{};

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
                            rootNS[partNS](vehicle. part, nil);
                            vehicle:doDamageOverlay();
                        end
                    end

                    for i, partFn in ipairs({"Init", "InstallComplete", "UninstallComplete"})
                    do
                        if not rootNS[partFn][partNS]
                        then
                            rootNS[partFn][partNS]= function(vehicle, part)
                                if partFn == "Init"
                                then
                                    --Check default parts
                                    local vName = vehicle:getScript():getName();

                                    if not boltz.loadedParts[vName]
                                    then
                                        boltz.loadedParts[vName] = {
                                            rootNS = rootNS,
                                            parts = {}
                                        }
                                    end

                                    if not boltz.loadedParts[vName].parts[partNS]
                                    then
                                        boltz.loadedParts[vName].parts[partNS] = true;
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

function boltz:checkDefaultParts(vehicle, part, partConfig)
    local partId = part:getId();
    local modData = boltz:getModData(vehicle);

    if not modData["defaultPartSet_" .. partId]
    then
        if part:getTable("install")
        then
            local item = nil;

            --Each item type (FrontBumper, RearBumper) would only have one variant for now, will have to expand once more are added
            local possibilities = part:getItemType();
            item = possibilities:get(0);

            if boltz.partDefaultsDebug and item
            then
                print("boltz:checkDefaultParts() -> would install item " .. tostring(item) .. " in slot " .. partId);
            end
        end
        
        if not boltz.partDefaultsDebug
        then 
            boltz:saveModData(vehicle, {
                ["defaultPartSet_" .. partId] = "true"
            });
        end
    end
end

boltz.muleParts = boltz.muleParts or {
    "GloveBox",
    "TruckBed",
    "Engine",
}

function boltz:getMulePart(vehicle)
    if vehicle
    then
        for i, partId in ipairs(boltz.muleParts)
        do
            local part = vehicle:getPartById(partId);

            if part
            then
                return part;
            end
        end
    end
    return nil;
end


function boltz:getModData(vehicle)
    local part = boltz:getMulePart(vehicle);

    if part
    then
        return part:getModData();
    else
        print("boltz:getModData() -> data mule part NOT found");
    end
end

function boltz:saveModData(vehicle, data)
    boltz:sendClientCommand("boltz_lib", "setVehicleData", data, vehicle);
end

function boltz:sendClientCommand(moduleName, methodName, args, vehicle)
    if vehicle
    then
        args["_vehicleId"] = vehicle:getId();
    end

    sendClientCommand(getPlayer(), moduleName, methodName, args);
end
