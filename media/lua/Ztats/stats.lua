require "Ztats/Conf";
require "Ztats/DateTimeClass";
require "Ztats/ActionStats";
require "Ztats/DisplayStats";

ProjectStats = {};
ProjectStats.allStats = nil;

ProjectStats.tick = function()
	
	local oGameTime = GameTime:getInstance();
	local oPlayerData = getPlayer():getModData();
	
	ActionStats.updateTimeSurvived(oGameTime, oPlayerData);
end

ProjectStats.itemUsed = function(character, item)
	if character:getObjectName() == 'Player' then
		local oPlayerData = character:getModData();
		ActionStats.updateItemStats(item, oPlayerData);
	end
end

ProjectStats.weaponUsed = function(character, weapon)
	if character:getObjectName() == 'Player' then
		local oPlayerData = character:getModData();
		ActionStats.updateItemStats(weapon, oPlayerData);
	end
end

ProjectStats.playerUpdate = function(oPlayer)
	local oPlayerData = oPlayer:getModData();
	ProjectStats.allStats = oPlayerData;
	
	local oGameTime = GameTime:getInstance();
	
	ActionStats.updateTimeSleeped(oGameTime, oPlayer, oPlayerData);
	ActionStats.updateDistanceWalked(oPlayer, oPlayerData);
	
	--***************************************
	--Affichage debug
	--***************************************
	--oPlayer:Say(DisplayStats.getDistanceWalked(oPlayerData.distanceWalked));
	--***************************************	
end

ProjectStats.zombieUpdate = function(oZombie)
	local oPlayer = getPlayer();
	local oPlayerData = oPlayer:getModData();
	
	ActionStats.updateHitWeapon(oZombie, oPlayer, oPlayerData);
end

ProjectStats.NPCUpdate = function(oNPC)
	local oPlayer = getPlayer();
	local oPlayerData = oPlayer:getModData();
	
	ActionStats.updateHitWeapon(oNPC, oPlayer, oPlayerData);
end

ProjectStats.showStatsWindow = function()
	local oTextManager = getTextManager();
	
	if(ProjectStats.allStats ~= nil) then
		DisplayStats:showWindow();
	end
end


Events.OnUseItem.Add(ProjectStats.itemUsed);
Events.OnWeaponSwingHitPoint.Add(ProjectStats.weaponUsed);
Events.OnPlayerUpdate.Add(ProjectStats.playerUpdate);
Events.OnTick.Add(ProjectStats.tick);
Events.OnPostUIDraw.Add(ProjectStats.showStatsWindow);
Events.OnZombieUpdate.Add(ProjectStats.zombieUpdate);
Events.OnNPCSurvivorUpdate.Add(ProjectStats.NPCUpdate);