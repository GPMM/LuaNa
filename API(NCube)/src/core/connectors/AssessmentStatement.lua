local NCLElem = require "core/NCLElem"
local AttributeAssessment = require "core/connectors/AttributeAssessment"
local ValueAssessment = require "core/connectors/ValueAssessment"

local AssessmentStatement = NCLElem:extends()

AssessmentStatement.nameElem = "assessmentStatement"

AssessmentStatement.childrenMap = {
  attributeAssessment = {AttributeAssessment, "many"},
  valueAssessment = {ValueAssessment, "one"}
}

AssessmentStatement.attributesTypeMap = {
  comparator = "string"
}

AssessmentStatement.attributesStringValueMap = {
  comparator = {"eq", "ne", "gt", "lt", "gte", "lte"}
}

function AssessmentStatement:create(attributes, full)
  local assessmentStatement = AssessmentStatement:new()

  assessmentStatement.comparator = nil

  if(attributes ~= nil)then
    assessmentStatement:setAttributes(attributes)
  end

  assessmentStatement.children = {}
  assessmentStatement.attributeAssessments = {}

  if(full ~= nil)then
    assessmentStatement:addAttributeAssessment(AttributeAssessment:create())
    assessmentStatement:setValueAssessment(ValueAssessment:create())
  end

  return assessmentStatement
end

function AssessmentStatement:setComparator(comparator)
  self:addAttribute("comparator", comparator)
end

function AssessmentStatement:getComparator()
  return self:getAttribute("comparator")
end

function AssessmentStatement:addAttributeAssessment(attributeAssessment)
  if((type(attributeAssessment) == "table"
    and attributeAssessment["getNameElem"] ~= nil
    and attributeAssessment:getNameElem() ~= "attributeAssessment")
    or (type(attributeAssessment) == "table"
    and attributeAssessment["getNameElem"] == nil)
    or type(attributeAssessment) ~= "table")then
    error("Error! Invalid attributeAssessment element!", 2)
  end

  local p = self:getPosAvailable("attributeAssessment")

  if(p ~= nil)then
    self:addChild(attributeAssessment, p)
  else
    self:addChild(attributeAssessment, 1)
  end

  table.insert(self.attributeAssessments, attributeAssessment)
end

function AssessmentStatement:getAttributeAssessmentPos(p)
  if(self.attributeAssessments == nil)then
    error("Error! assessmentStatement element with nil attributeAssessments list!", 2)
  elseif(p > #self.attributeAssessments)then
    error("Error! assessmentStatement element doesn't have an attributeAssessment child in position "..p.."!", 2)
  end

  return self.attributeAssessments[p]
end

function AssessmentStatement:setAttributeAssessments(...)
  if(#arg>0)then
    for _, attributeAssessment in ipairs(arg) do
      self:addAttributeAssessment(attributeAssessment)
    end
  end
end

function AssessmentStatement:removeAttributeAssessment(attributeAssessment)
  if((type(attributeAssessment) == "table"
    and attributeAssessment["getNameElem"] ~= nil
    and attributeAssessment:getNameElem() ~= "attributeAssessment")
    or (type(attributeAssessment) == "table"
    and attributeAssessment["getNameElem"] == nil)
    or type(attributeAssessment) ~= "table")then
    error("Error! Invalid attributeAssessment element!", 2)
  elseif(self.children == nil)then
    error("Error! assessmentStatement element with nil children list!", 2)
  elseif(self.attributeAssessments == nil)then
    error("Error! assessmentStatement element with nil attributeAssessments list!", 2)
  end

  self:removeChild(attributeAssessment)

  for p, aa in ipairs(self.attributeAssessments) do
    if(attributeAssessment == aa)then
      table.remove(self.attributeAssessments, p)
    end
  end
end

function AssessmentStatement:removeAttributeAssessmentPos(p)
  if(self.children == nil)then
    error("Error! assessmentStatement element with nil children list!", 2)
  elseif(self.attributeAssessments == nil)then
    error("Error! assessmentStatement element with nil attributeAssessments list!", 2)
  elseif(p > #self.children)then
    error("Error! assessmentStatement element doesn't have a attributeAssessment child in position "..p.."!", 2)
  elseif(p > #self.attributeAssessments)then
    error("Error! assessmentStatement element doesn't have a attributeAssessment child in position "..p.."!", 2)
  end

  self:removeChild(self.attributeAssessments[p])
  table.remove(self.attributeAssessments, p)
end

function AssessmentStatement:setValueAssessment(valueAssessment)
  if((type(valueAssessment) == "table"
    and valueAssessment["getNameElem"] ~= nil
    and valueAssessment:getNameElem() ~= "valueAssessment")
    or (type(valueAssessment) == "table"
    and valueAssessment["getNameElem"] == nil)
    or type(valueAssessment) ~= "table")then
    error("Error! Invalid valueAssessment element!", 2)
  end

  local p

  if(self.valueAssessment == nil)then
    p = self:getPosAvailable("attributeAssessment")
    if(p ~= nil)then
      self:addChild(valueAssessment, p)
    else
      self:addChild(valueAssessment, 1)
    end
  else
    p = self:getPosAvailable("valueAssessment") - 1
    self:removeChildPos(p)
    self:addChild(valueAssessment, p)
  end

  self.valueAssessment = valueAssessment
end

function AssessmentStatement:getValueAssessment()
  return self.valueAssessment
end

function AssessmentStatement:removeValueAssessment()
  self:removeChild(self.valueAssessment)
  self.valueAssessment = nil
end

return AssessmentStatement