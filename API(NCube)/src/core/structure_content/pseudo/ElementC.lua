local NCLElem = require "core/structure_content/NCLElem"
local ElementE = require "core/structure_content/pseudo/ElementE"

local ElementC = NCLElem:extends()

ElementC.name = "elementC"

ElementC.childrenMap = {
 ["elementE"] = {ElementE, "many"}
}

function ElementC:create(attributes, full)   
   local elementC = ElementC:new()   
   
   elementC.attributes = {
      ["id"] = "",  
      ["desc"] = ""
   }
   
   if(attributes ~= nil)then
      elementC:setAttributes(attributes)
   end
   
   elementC.children = {}
   elementC.elementsE = {}
   
   if(full ~= nil)then
      elementC:addElementE(ElementE:create())     
   end
      
   return elementC
end

function ElementC:setId(id)
   self:addAttribute("id", id)
end

function ElementC:getId()
   return self:getAttribute("id")
end

function ElementC:setDesc(desc)
   self:addAttribute("desc", desc)
end

function ElementC:getDesc()
   return self:getAttribute("desc")
end

function ElementC:addElementE(elementE)
    table.insert(self.elementsE, elementE)    
    local p = self:getPosAvailable("elementE")
    if(p ~= nil)then
       self:addChild(elementE, p)
    else
       self:addChild(elementE, 1)
    end
end

function ElementC:getElementEPos(i)
    return self.elementsE[i]
end

function ElementC:getElementEById(id)
   for _, elementE in ipairs(self.elementsE) do
       if(elementE:getId() == id)then
          return elementE
       end
   end
   
   return nil
end

function ElementC:setElementsE(...)
    if(#arg>0)then
      for _, elementE in ipairs(arg) do
          self:addElementE(elementE)
      end
    end
end

function ElementC:removeElementsE(elementE)
   self:removeChild(elementE)
   
   for i, elem4 in ipairs(self.elementsE) do
       if(elementE == elemE)then
           table.remove(self.elementsE, i)  
       end
   end    
end

function ElementC:removeElementEPos(i)
   self:removeChildPos(i)
   table.remove(self.elementsE, i)
end

return ElementC