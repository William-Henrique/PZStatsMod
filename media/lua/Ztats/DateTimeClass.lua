require "Ztats/String";

DateTimeClass = {};

function DateTimeClass:new(iDay, iMonth, iYear, fHours)
	local o = {};
	setmetatable(o, self);
    self.__index = self;
	o:initialise(iDay, iMonth, iYear, fHours);
	
	return o;
end

function DateTimeClass:newFromTimestamp(iTimestamp)
	local o = {};
	setmetatable(o, self);
    self.__index = self;
	o.timestamp = iTimestamp;
	
	return o;
end

function DateTimeClass:initialise(iDay, iMonth, iYear, fHours)
	local o = {};
	
	o.day = iDay or 1;
	o.month = iMonth or 1;
	o.year = iYear or 1970;
	fHours = fHours or 0;
	
	o.sec = math.floor(fHours * 3600);
	o.hour = math.floor(o.sec / 3600);
	o.min = math.floor(o.sec / 60) - o.hour * 60;
	o.sec = math.fmod(o.sec, 60);
	
	self.timestamp = os.time(o);
	
end

function DateTimeClass:formatDate(sFormat)
	local oDate = os.date('*t', self.timestamp);	
	
	oDate.year = oDate.year - 1970;
	oDate.month = oDate.month - 1;
	oDate.day = oDate.day - 1;
		
	local substitute = {
		d = string.lpad(tostring(oDate.day), 2, '0'),
		j = tostring(oDate.day),
		m = string.lpad(tostring(oDate.month), 2, '0'),
		n = tostring(oDate.month),
		y = tostring(oDate.year),
		h = string.lpad(tostring(oDate.hour), 2, '0'),
		G = tostring(oDate.hour),
		i = string.lpad(tostring(oDate.min), 2, '0'),
		s = string.lpad(tostring(oDate.sec), 2, '0')
	}
	
	sFormat =  string.gsub(sFormat, "%$(%a)", substitute);
	
	return sFormat;
end

function DateTimeClass:diff(oDateTime)
	local diffDateTime= DateTimeClass:new(nil, nil, nil, nil);
	
	diffDateTime.timestamp = self.timestamp - oDateTime.timestamp;
	return diffDateTime;
end

function DateTimeClass:sum(oDateTime)
	local totalDateTime= DateTimeClass:new(nil, nil, nil, nil);
	
	totalDateTime.timestamp = self.timestamp + oDateTime.timestamp;
	return totalDateTime;
end