GOD = GOD or {};

GOD.loadedParts = GOD.loadedParts or {};
GOD.partDefaultDebug = false;
GOD.modDataDebug = false;

function GOD:createVehicleConfig(rootNS)
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

                                    if not GOD.loadedParts[vName]
                                    then
                                        GOD.loadedParts[vName] = {
                                            rootNS = rootNS,
                                            parts = {}
                                        }
                                    end

                                    if not GOD.loadedParts[vName].parts[partNS]
                                    then
                                        GOD.loadedParts[vName].parts[partNS] = true;
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

function GOD:checkDefaultParts(vehicle, part, partConfig)
    local partId = part:getId();
    local modData = GOD:getModData(vehicle);

    if not modData["defaultPartSet_" .. partId]
    then
        if part:getTable("install")
        then
            local item = nil;

            --Each item type (FrontBumper, RearBumper) would only have one variant for now, will have to expand once more are added
            local possibilities = part:getItemType();
            item = possibilities:get(0);

            if GOD.partDefaultsDebug and item
            then
                print("GOD:checkDefaultParts() -> would install item " .. tostring(item) .. " in slot " .. partId);
            end
        end
        
        if not GOD.partDefaultsDebug
        then 
            GOD:saveModData(vehicle, {
                ["defaultPartSet_" .. partId] = "true"
            });
        end
    end
end

GOD.muleParts = GOD.muleParts or {
    "GloveBox",
    "TruckBed",
    "Engine",
}

function GOD:getMulePart(vehicle)
    if vehicle
    then
        for i, partId in ipairs(GOD.muleParts)
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


function GOD:getModData(vehicle)
    local part = GOD:getMulePart(vehicle);

    if part
    then
        return part:getModData();
    else
        print("GOD:getModData() -> data mule part NOT found");
    end
end

function GOD:saveModData(vehicle, data)
    GOD:sendClientCommand("GOD_lib", "setVehicleData", data, vehicle);
end

function GOD:sendClientCommand(moduleName, methodName, args, vehicle)
    if vehicle
    then
        args["_vehicleId"] = vehicle:getId();
    end

    sendClientCommand(getPlayer(), moduleName, methodName, args);
end
