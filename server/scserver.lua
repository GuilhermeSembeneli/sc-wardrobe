---------------------------------------------------------------------------------------------------------
--VRP
---------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
SC = {}
Tunnel.bindInterface("sc-wardrobe",SC)

---------------------------------------------------------------------------------------------------------
--FUNCTION
---------------------------------------------------------------------------------------------------------
SC.ClothesWardrobe = function(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if name then 
		local custom = SConfig.presets[name]
		if custom then
			local old_custom = vRPclient.getCustomization(source)
			local idle_copy = {}
			idle_copy = vRP.save_idle_custom(source,old_custom)
			idle_copy.modelhash = nil

			for l,w in pairs(custom[old_custom.modelhash]) do
				idle_copy[l] = w
			end
			vRPclient._setCustomization(source,idle_copy)
		end
	end
end

SC.RemoveClothes = function()
	local source = source
	vRP.removeCloak(source)
end


SC.CheckPerm = function(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id, perm)
end

SC.GetPerm = function()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, "policia.permissao") then
		return 'Policia'
	elseif vRP.hasPermission(user_id, "paramedico.permissao") then
		return 'Policia'
	elseif vRP.hasPermission(user_id, "mecanico.permissao") then
		return 'Mecanico'
	end
end