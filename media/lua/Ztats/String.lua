string.lpad = function(str, len, char)
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str;
end