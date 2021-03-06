local NCLElem = require "core/NCLElem"

local LinkParam = NCLElem:extends()

LinkParam.nameElem = "linkParam"

LinkParam.attributesTypeMap = {
  name = "string",
  value = {"string", "number"}
}

function LinkParam:create(attributes)  
   local linkParam = LinkParam:new() 
   
   linkParam.name = nil
   linkParam.value = nil
   
   linkParam.symbols = {}
   
   if(attributes ~= nil)then
      linkParam:setAttributes(attributes)
   end
      
   return linkParam
end

function LinkParam:setName(name)
   self:addAttribute("name", name)
end

function LinkParam:getName()
   return self:getAttribute("name")
end

function LinkParam:setValue(value)
   self:addAttribute("value", value)
end

function LinkParam:getValue()
   return self:getAttribute("value")
end

return LinkParam