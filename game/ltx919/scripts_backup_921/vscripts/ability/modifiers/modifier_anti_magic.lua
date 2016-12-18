if modifier_anti_magic == nil then
    modifier_anti_magic = class({})
end
--绿色的林肯特效

function modifier_anti_magic:GetTexture()
	return "anti_magic"
end

function modifier_anti_magic:IsHidden()
	return true
end