require 'Vehicles/Vehicles';

function Vehicles.UninstallTest.boltz_930turbo_Uninstall2(vehicle, part, chr)
	if ISVehicleMechanics.cheat then return true; end
	local keyvalues = part:getTable("uninstall")
	if not keyvalues then return false end
	if not part:getInventoryItem() then return false end
	if not part:getItemType() or part:getItemType():isEmpty() then return false end
	local typeToItem = VehicleUtils.getItems(chr:getPlayerNum())
	if keyvalues.requireUninstalled and (vehicle:getPartById(keyvalues.requireUninstalled) and vehicle:getPartById(keyvalues.requireUninstalled):getInventoryItem()) then
		return false;
	end
	if keyvalues.requireUninstalled2 and (vehicle:getPartById(keyvalues.requireUninstalled2) and vehicle:getPartById(keyvalues.requireUninstalled2):getInventoryItem()) then
		return false;
	end
	if not VehicleUtils.testProfession(chr, keyvalues.professions) then return false end
	if not VehicleUtils.testRecipes(chr, keyvalues.recipes) then return false end
	if not VehicleUtils.testTraits(chr, keyvalues.traits) then return false end
	if not VehicleUtils.testItems(chr, keyvalues.items, typeToItem) then return false end
	if keyvalues.requireEmpty and round(part:getContainerContentAmount(), 3) > 0 then return false end
	local seatNumber = part:getContainerSeatNumber()
	local seatOccupied = (seatNumber ~= -1) and vehicle:isSeatOccupied(seatNumber)
	if keyvalues.requireEmpty and seatOccupied then return false end
	if VehicleUtils.RequiredKeyNotFound(part, chr) then
		return false
	end
	return true
end