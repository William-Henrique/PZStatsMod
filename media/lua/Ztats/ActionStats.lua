ActionStats = {};

ActionStats.bPlayerIsAlreadySleeping = false;
ActionStats.oDateStartSleeping = nil;
ActionStats.oDateStopSleeping = nil;
ActionStats.playerX = nil;
ActionStats.playerY = nil;
ActionStats.playerZ = nil;

ActionStats.updateTimeSurvived = function(oGameTime, oPlayerData)
	
	local oStartTime = DateTimeClass:new(oGameTime:getStartDay() + 1, oGameTime:getStartMonth() + 1, oGameTime:getStartYear(), oGameTime:getStartTimeOfDay());
	local oCurrentTime = DateTimeClass:new(oGameTime:getDay() + 1, oGameTime:getMonth() + 1, oGameTime:getYear(), oGameTime:getTimeOfDay());
	local oDiff = oCurrentTime:diff(oStartTime);
	oPlayerData.timeSurvived = oDiff.timestamp;
end


ActionStats.updateTimeSleeped = function(oGameTime, oPlayer, oPlayerData)
	
	oPlayerData.timeSleeped = oPlayerData.timeSleeped or 0;
	oDateTimeSleeped = DateTimeClass:newFromTimestamp(oPlayerData.timeSleeped);
	
	if oPlayer:isAsleep() then
		if not ActionStats.bPlayerIsAlreadySleeping then
			ActionStats.oDateStartSleeping = DateTimeClass:new(oGameTime:getDay() + 1, oGameTime:getMonth() + 1, oGameTime:getYear(), oGameTime:getTimeOfDay());
			ActionStats.bPlayerIsAlreadySleeping = true;
		end
	else
		if ActionStats.bPlayerIsAlreadySleeping then
			ActionStats.oDateStopSleeping = DateTimeClass:new(oGameTime:getDay() + 1, oGameTime:getMonth() + 1, oGameTime:getYear(), oGameTime:getTimeOfDay());
			
			if ActionStats.oDateStartSleeping ~= nil then
				diffDate = ActionStats.oDateStopSleeping:diff(ActionStats.oDateStartSleeping);
				local oTotalTimeSleeped = diffDate:sum(oDateTimeSleeped);
				oPlayerData.timeSleeped = oTotalTimeSleeped.timestamp;
			end
			ActionStats.bPlayerIsAlreadySleeping = false;
		end
	end
end

ActionStats.updateDistanceWalked = function(oPlayer, oPlayerData)
	oPlayerData.distanceWalked = oPlayerData.distanceWalked or 0;
	
	local posX = oPlayer:getX();
	local posY = oPlayer:getY();
	local posZ = oPlayer:getZ();
	
	ActionStats.playerX = ActionStats.playerX or posX;
	ActionStats.playerY = ActionStats.playerY or posY;
	ActionStats.playerZ = ActionStats.playerZ or posZ;
	
	local diff = math.abs(math.sqrt((ActionStats.playerX - posX)^2 + (ActionStats.playerY - posY)^2 + (ActionStats.playerZ - posZ)^2));
	-- Prevent adding distance when changing cell
	if diff < 10 then
		oPlayerData.distanceWalked = oPlayerData.distanceWalked + diff;
	end
	
	ActionStats.playerX = posX;
	ActionStats.playerY = posY;
	ActionStats.playerZ = posZ;

end

ActionStats.updateItemStats = function(item, oPlayerData)
	local itemName = string.gsub(item:getName(),"(.*)(%d+)", "%1");
	local itemKey =  tostring(item:getCat()) .. ':' .. itemName;
	oPlayerData[itemKey] = oPlayerData[itemKey] or 0;
	oPlayerData[itemKey] = oPlayerData[itemKey] + 1;
	
	oPlayerData[tostring(item:getCat())] = oPlayerData[tostring(item:getCat())] or 0;
	oPlayerData[tostring(item:getCat())] = oPlayerData[tostring(item:getCat())] + 1;
end

ActionStats.updateHitWeapon = function(oCharacter, oPlayer, oPlayerData)
	local hitBy = oCharacter:getHitBy();
	
	oPlayerData.nbZombieKilled = oPlayerData.nbZombieKilled or 0;
	oPlayerData.nbSurvivorKilled = oPlayerData.nbSurvivorKilled or 0;
	
	if hitBy ~= nil and hitBy:getObjectName() == 'Player' then
		local oWeaponUsed = oPlayer:getUseHandWeapon();
		local weaponName = string.gsub(oWeaponUsed:getName(),"(.*)(%d+)", "%1");
		local hitStatsWeapon = 'HitWeapon:' .. weaponName;
		oPlayerData[hitStatsWeapon] = oPlayerData[hitStatsWeapon] or 0;
		oPlayerData[hitStatsWeapon] = oPlayerData[hitStatsWeapon] + 1;
		
		if oCharacter:isDead() then
			if(oCharacter:getObjectName() == 'Zombie') then
				oPlayerData.nbZombieKilled = oPlayerData.nbZombieKilled + 1;
			else
				oPlayerData.nbSurvivorKilled = oPlayerData.nbSurvivorKilled + 1;
			end
		end
		
		oCharacter:setHitBy(nil);
	end
end