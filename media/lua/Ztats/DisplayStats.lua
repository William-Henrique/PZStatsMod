DisplayStats = {};

DisplayStats.showWindow = function()
	oTextManager = getTextManager();
	local oTime = DateTimeClass:newFromTimestamp(ProjectStats.allStats.timeSleeped);
	
	oTextManager:DrawString(UIFont.Small, 60, 200, 'You slept ', 1, 1, 1, 1);
	oTextManager:DrawString(UIFont.Small, 115, 200, tostring(oTime:formatDate('$j days, $G hours and $i minutes')), 0, 1, 0, 1);
		
	oTime = DateTimeClass:newFromTimestamp(ProjectStats.allStats.timeSurvived);
	oTextManager:DrawString(UIFont.Small, 60, 215, 'You survived ', 1, 1, 1, 1);
	oTextManager:DrawString(UIFont.Small, 135, 215, tostring(oTime:formatDate('$j days, $G hours and $i minutes')), 0, 1, 0, 1);
		
	oTextManager:DrawString(UIFont.Small, 60, 230, 'You walked ', 1, 1, 1, 1);
	oTextManager:DrawString(UIFont.Small, 130, 230, DisplayStats.getDistanceWalked(ProjectStats.allStats.distanceWalked), 0, 1, 0, 1);
	
	oTextManager:DrawString(UIFont.Small, 60, 245, 'You killed ', 1, 1, 1, 1);
	oTextManager:DrawString(UIFont.Small, 120, 245, tostring(ProjectStats.allStats.nbZombieKilled) .. ' zombies and ' .. tostring(ProjectStats.allStats.nbSurvivorKilled) .. ' NPCs', 0, 1, 0, 1);
	
	if isKeyDown(Conf.keyStatsKills) then
		DisplayStats.showKillCounter(oTextManager);
	end
	
	if isKeyDown(Conf.keyStatsFood) then
		local background = getTexture("media/ui/Ztats/background.png");
		local core = getCore();
		local posX = (core:getScreenWidth() - background:getWidth()) / 2;
		local posY = (core:getScreenHeight() - background:getHeight()) / 2;
		
		background:render(posX, posY);
		
		local nbLine = 0;
		local colX = 0;
		-- Show Food
		if ProjectStats.allStats.Food == nil then
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 10, 'Food eaten: None', 1, 1, 1, 1);
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 20, '-----------------', 1, 1, 1, 1);
		else
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 10, 'Food eaten: x' .. tostring(ProjectStats.allStats.Food), 1, 1, 1, 1);
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 20, '-----------------', 1, 1, 1, 1);
			for k,o in pairs(ProjectStats.allStats) do
				for itemName in string.gmatch(k, "Food:(.+)") do
					local itemNameDisplayed = itemName .. ': ';
					local stringSize = oTextManager:MeasureStringX(UIFont.Small, itemNameDisplayed);
					oTextManager:DrawString(UIFont.Small, posX + 10 + colX, posY + 35 + 15 * nbLine, itemNameDisplayed , 1, 1, 1, 1);
					oTextManager:DrawString(UIFont.Small, posX + 10 + colX + stringSize, posY + 35 + 15 * nbLine, 'x' .. tostring(o) .. ' (' .. string.format('%0.2f', o * 100 / ProjectStats.allStats.Food) .. '%)' , 0, 1, 0, 1);
					nbLine = nbLine + 1;
					if(nbLine > 15) then
						colX = 300;
						nbLine = 0;
					end
				end	
			end
		end
	end
	
	if isKeyDown(Conf.keyStatsWeapon) then
		local background = getTexture("media/ui/Ztats/background.png");
		local core = getCore();
		local posX = (core:getScreenWidth() - background:getWidth()) / 2;
		local posY = (core:getScreenHeight() - background:getHeight()) / 2;
		
		background:render(posX, posY);
		
		local nbLine = 0;
		local colX = 0;
		-- Show Weapons
		if ProjectStats.allStats.Weapon == nil then
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 10, 'Weapons used: None', 1, 1, 1, 1);
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 20, '-----------------', 1, 1, 1, 1);
		else
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 10, 'Weapons used: x' .. tostring(ProjectStats.allStats.Weapon), 1, 1, 1, 1);
			oTextManager:DrawString(UIFont.Small, posX + 10, posY + 20, '-----------------', 1, 1, 1, 1);
			for k,o in pairs(ProjectStats.allStats) do
				for itemName in string.gmatch(k, "^Weapon:(.+)") do
					local itemNameDisplayed = itemName .. ': ';
					
					local hitStatsWeaponKey = 'HitWeapon:' .. itemName;
					if ProjectStats.allStats[hitStatsWeaponKey] == nil then
						hitStatsWeapon = 0;
					else
						hitStatsWeapon = ProjectStats.allStats[hitStatsWeaponKey];
					end
					
					local stringSize = oTextManager:MeasureStringX(UIFont.Small, itemNameDisplayed);
					oTextManager:DrawString(UIFont.Small, posX + 10 + colX, posY + 35 + 15 * nbLine, itemNameDisplayed , 1, 1, 1, 1);
					oTextManager:DrawString(UIFont.Small, posX + 10 + colX + stringSize, posY + 35 + 15 * nbLine, 'x' .. tostring(o) .. ' (' .. string.format('%0.2f', o * 100 / ProjectStats.allStats.Weapon) .. '%) - Precision: ' .. string.format('%0.2f', hitStatsWeapon * 100 / o) ..'% (' .. hitStatsWeapon .. ' hits)' , 0, 1, 0, 1);
					nbLine = nbLine + 1;
					if(nbLine > 15) then
						colX = 300;
						nbLine = 0;
					end
				end
			end
		end
	end
end

DisplayStats.getDistanceWalked = function(distanceWalked)
	local convertWith = nil;
	local unit = nil;
	local divide = nil;
	if Conf.metric then
		convertWith = Conf.convertToMeters;
		unit = 'km';
		divide = 1000;
	else
		convertWith = Conf.convertToFeet;
		unit = 'mi';
		divide = 5280;
	end
	return(string.format('%0.3f', distanceWalked / convertWith / divide) .. ' ' .. unit);
end

DisplayStats.showKillCounter = function(oTextManager)
   
	local background = getTexture("media/ui/Ztats/background.png");
	local title = getTexture("media/ui/Ztats/title.png");
	local zeds = getTexture("media/ui/Ztats/zeds.png");
	local zedsText = getTexture("media/ui/Ztats/zeds_text.png");
	local npc = getTexture("media/ui/Ztats/npc.png");
	local npcText = getTexture("media/ui/Ztats/npc_text.png");
	local bloodZeds = getTexture("media/ui/Ztats/blood1.png");
	local bloodNpc = getTexture("media/ui/Ztats/blood2.png");
	
	local core = getCore();
	local posX = (core:getScreenWidth() - background:getWidth()) / 2;
	local posY = (core:getScreenHeight() - background:getHeight()) / 2;
	
	background:render(posX, posY);
	title:render(posX + 110, posY + 10);
	zeds:render(posX - 20, posY + 110);
	zedsText:render(posX + 15, posY + 250);
	npc:render(posX + 360, posY + 80);
	npcText:render(posX + 415, posY + 250);
	bloodZeds:render(posX + 110, posY + 178);
	bloodNpc:render(posX + 300, posY + 184);
	
	oTextManager:DrawStringCentre(UIFont.Massive, posX + 165, posY + 230, tostring(ProjectStats.allStats.nbZombieKilled), 1, 1, 1, 0.8);
	oTextManager:DrawStringCentre(UIFont.Massive, posX + 355, posY + 230, tostring(ProjectStats.allStats.nbSurvivorKilled), 1, 1, 1, 0.8);
end