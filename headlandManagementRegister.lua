--
-- register
--
-- Jason06 / Glowins Modschmiede 
-- Version 0.6.0.0
--
-- 
--
function addHLMconfig(xmlFile, superfunc, baseXMLName, baseDir, customEnvironment, isMod, storeItem)
    local configurations = superfunc(xmlFile, baseXMLName, baseDir, customEnvironment, isMod, storeItem)
	dbgprint("addHLMconfig : Kat: "..storeItem.categoryName.." / ".."Name: "..storeItem.xmlFilename)

	local category = storeItem.categoryName
	if 
			category == "TRACTORSS" 
		or	category == "TRACTORSM"
		or	category == "TRACTORSL"
		or	category == "HARVESTERS"
		or	category == "FORAGEHARVESTERS"
		or	category == "BEETVEHICLES"
		or	category == "POTATOVEHICLES"
		or	category == "COTTONVEHICLES"
		or	category == "SPRAYERVEHICLES"
		or	category == "SUGARCANEVEHICLES"
		or	category == "MOWERVEHICLES"
		or	category == "MISCVEHICLES"
		
		and	configurations ~= nil

	then
		configurations["headlandManagement"] = {
        	{name = "Nein", index = 1, isDefault = true,  price = 0, dailyUpkeep = 0, desc = g_i18n:getText("text_HLM_notInstalled")},
        	{name = "Ja", index = 2, isDefault = false, price = 3000, dailyUpkeep = 0, desc = g_i18n:getText("text_HLM_installed")}
    	}
	end
	
    return configurations
end

if g_specializationManager:getSpecializationByName("HeadlandManagement") == nil then
  	g_specializationManager:addSpecialization("HeadlandManagement", "HeadlandManagement", g_currentModDirectory.."headlandManagement.lua", true, nil)
end

for typeName, typeEntry in pairs(g_vehicleTypeManager:getVehicleTypes()) do
    if
    		SpecializationUtil.hasSpecialization(Drivable, typeEntry.specializations) 
		and	SpecializationUtil.hasSpecialization(Enterable, typeEntry.specializations)
		and	SpecializationUtil.hasSpecialization(Motorized, typeEntry.specializations)
    
    	and not
    
		(
    		SpecializationUtil.hasSpecialization(Locomotive, typeEntry.specializations)
		or	SpecializationUtil.hasSpecialization(ConveyorBelt, typeEntry.specializations)
    	)
    
    then
     	g_vehicleTypeManager:addSpecialization(typeName, "HeadlandManagement")
		dbgprint("registered for "..typeName)
    end
end

if g_configurationManager.configurations["HeadlandManagement"] == nil then
	g_configurationManager:addConfigurationType("HeadlandManagement", g_i18n:getText("text_HLM_configuration"), nil, nil, nil, nil, ConfigurationUtil.SELECTOR_MULTIOPTION)
	StoreItemUtil.getConfigurationsFromXML = Utils.overwrittenFunction(StoreItemUtil.getConfigurationsFromXML, addHLMconfig)
end

-- make localizations available
local i18nTable = getfenv(0).g_i18n
for l18nId,l18nText in pairs(g_i18n.texts) do
  i18nTable:setText(l18nId, l18nText)
end
