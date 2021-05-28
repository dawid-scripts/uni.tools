--[[
    Fade is an extenstion that allows you to quickly tween all elements in a frame to disappear, or appear.
    
    Example Usage:
    Fade:Fade(Frame, 1, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	wait(2)
	Fade:Revert(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
]]
local TweenService = game:GetService('TweenService')

local Fade = {
    Storage = {},
	Types = {
		'BackgroundTransparency',
		'TextTransparency',
		'TextStrokeTransparency',
		'ImageTransparency'
	}
}

local function GetProperties(obj, strg)
	local tempstorage = {}
	for _,v in next, Fade.Types do
        pcall(function()
            if return obj[v] then
                tempstorage[v] = obj[v]
            end    
        end)
	end
	strg[obj] = tempstorage
end

local function Tween(strg, trans, tweeninfo)
	for i, v in next, strg do
		local temp = {}
		for g, c in next, v do
			temp[g] = c + ((1 - c) * trans)
		end
		TweenService:Create(i, tweeninfo or TweenInfo.new(0), temp):Play()
	end
end

function Fade:Revert(obj,  tweeninfo)
	local strg = self.Storage[obj]
	if strg then
		Tween(strg, 0, tweeninfo)
	end
end

function Fade:Fade(obj, trans, tweeninfo)
	local strg = self.Storage[obj]
	if not strg then
		strg = {}
		GetProperties(obj, strg)
		for _, v in next, obj:GetDescendants() do
			GetProperties(v, strg)
		end
		self.Storage[obj] = strg
	end
	Tween(strg, trans, tweeninfo)
end


return Fade
