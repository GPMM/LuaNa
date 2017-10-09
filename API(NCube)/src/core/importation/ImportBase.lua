local NCLElem = require "core/NCLElem"

local ImportBase = NCLElem:extends()

ImportBase.name = "importBase"

function ImportBase:create(attributes)
   local importBase = ImportBase:new()
   
   importBase.attributes = { 
    ["alias"] = "",
    ["documentURI"] = "", 
    ["region"] = "", 
    ["baseId"] = ""
   }
   
   if(attributes ~= nil)then
      importBase:setAttributes(attributes)
   end
   
   return importBase
end

function ImportBase:setAlias(alias)
    self:addAttribute("alias", alias)
end

function ImportBase:getAlias()
   return self:getAttribute("alias")
end

function ImportBase:setDocumentURI(documentURI)
    self:addAttribute("documentURI", documentURI)
end

function ImportBase:getDocumentURI()
   return self:getAttribute("documentURI")
end

function ImportBase:setRegion(region)
    self:addAttribute("region", region)
end

function ImportBase:getRegion()
   return self:getAttribute("region")
end

function ImportBase:setBaseId(baseId)
    self:addAttribute("baseId", baseId)
end

function ImportBase:getBaseId()
   return self:getAttribute("baseId")
end

return ImportBase