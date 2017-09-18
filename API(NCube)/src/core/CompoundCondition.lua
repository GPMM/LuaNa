local NCLElem = require "core/NCLElem"

local CompoundCondition = Class:createClass(NCLElem)

CompoundCondition.name = "compoundCondition"

CompoundCondition.attributes = {
  operator = nil,
  delay = nil
}

local SimpleCondition = require "core/SimpleCondition"

CompoundCondition.childsMap = {
 ["simpleCondition"] = {SimpleCondition, "many", 1}
}

CompoundCondition.simpleConditions = nil
CompoundCondition.compoundConditions = nil

function CompoundCondition:create(attributes, full)  
   local attributes = attributes or {}  
   local compoundCondition = CompoundCondition:new() 
     
   compoundCondition:setAttributes(attributes)
   compoundCondition:setChilds()
   
   if(full ~= nil)then      
      compoundCondition.simpleConditions = {}
      compoundCondition:addChild({} , 1)
      
      compoundCondition.compoundConditions = {}
      compoundCondition:addChild({} , 2)
   end
   
   return compoundCondition
end

function CompoundCondition:setOperator(operator)
   self.attributes.operator = operator
end

function CompoundCondition:getOperator()
   return self.attributes.operator
end

function CompoundCondition:setDelay(delay)
   self.attributes.delay = delay
end

function CompoundCondition:getDelay()
   return self.attributes.delay
end

function CompoundCondition:addSimpleCondition(simpleCondition)
    table.insert(self.simpleConditions, simpleCondition)
    table.insert(self:getChild(1), simpleCondition)
end

function CompoundCondition:getsimpleCondition(i)
    return self.simpleConditions[i]
end

function CompoundCondition:setSimpleConditions(...)
    if(#arg>0)then
      for i, v in ipairs(arg) do
          self:addSimpleCondition(v)
      end
    end
end

function CompoundCondition:addCompoundCondition(compoundCondition)
    table.insert(self.compoundConditions, compoundCondition)
    table.insert(self:getChild(1), compoundCondition)
end

function CompoundCondition:getCompoundCondition(i)
    return self.compoundConditions[i]
end

function CompoundCondition:setCompoundCondition(...)
    if(#arg>0)then
      for i, v in ipairs(arg) do
          self:addCompoundCondition(v)
      end
    end
end

CompoundCondition.childsMap["compoundCondition"] = {CompoundCondition, "many", 2}

return CompoundCondition