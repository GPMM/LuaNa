local NCLElem = require "core/NCLElem"
local ImportBase = require "core/importation/ImportBase"
local CausalConnector = require "core/connectors/CausalConnector"

local ConnectorBase = NCLElem:extends()

ConnectorBase.nameElem = "connectorBase"

ConnectorBase.childrenMap = {
  importBase = {ImportBase, "many"},
  causalConnector = {CausalConnector, "many"}
}

ConnectorBase.attributesTypeMap = {
  id = "string"
}

function ConnectorBase:create(attributes, full)
  local connectorBase = ConnectorBase:new()

  connectorBase.id = nil

  if(attributes ~= nil)then
    connectorBase:setAttributes(attributes)
  end

  connectorBase.children = {}
  connectorBase.importBases = {}
  connectorBase.causalConnectors = {}

  if(full ~= nil)then
    connectorBase:addImportBase(ImportBase:create())
    connectorBase:addCausalConnector(CausalConnector:create(nil, full))
  end

  return connectorBase
end

function ConnectorBase:setId(id)
  self:addAttribute("id", id)
end

function ConnectorBase:getId()
  return self:getAttribute("id")
end

function ConnectorBase:addImportBase(importBase)
  if((type(importBase) == "table"
    and importBase["getNameElem"] ~= nil
    and importBase:getNameElem() ~= "importBase")
    or (type(importBase) == "table"
    and importBase["getNameElem"] == nil)
    or type(importBase) ~= "table")then
    error("Error! Invalid importBase element!", 2)
  end

  self:addChild(importBase)
  table.insert(self.importBases, importBase)
end

function ConnectorBase:getImportBasePos(p)
  if(self.importBases == nil)then
    error("Error! connectorBase element with nil importBases list!", 2)
  elseif(p > #self.importBases)then
    error("Error! connectorBase element doesn't have a importBase child in position "..p.."!", 2)
  end

  return self.importBases[p]
end

function ConnectorBase:getImportBaseByAlias(alias)
  if(alias == nil)then
    error("Error! alias attribute of connectorbase element must be informed!", 2)
  elseif(self.importBases == nil)then
    error("Error! connectorBase element with nil importBases list!", 2)
  end

  for _, importBase in ipairs(self.importBases) do
    if(importBase:getAlias() == alias)then
      return importBase
    end
  end

  return nil
end

function ConnectorBase:setImportBases(...)
  if(#arg>0)then
    for _, importBase in ipairs(arg) do
      self:addRule(importBase)
    end
  end
end

function ConnectorBase:removeImportBase(importBase)
  if((type(importBase) == "table"
    and importBase["getNameElem"] ~= nil
    and importBase:getNameElem() ~= "importBase")
    or (type(importBase) == "table"
    and importBase["getNameElem"] == nil)
    or type(importBase) ~= "table")then
    error("Error! Invalid importBase element!", 2)
  elseif(self.children == nil)then
    error("Error! connectorBase element with nil children list!", 2)
  elseif(self.importBases == nil)then
    error("Error! connectorBase element with nil importBases list!", 2)
  end

  self:removeChild(importBase)

  for p, ib in ipairs(self.importBases) do
    if(importBase == ib)then
      table.remove(self.importBases, p)
    end
  end
end

function ConnectorBase:removeImportBasePos(p)
  if(self.children == nil)then
    error("Error! connectorBase element with nil children list!", 2)
  elseif(self.importBases == nil)then
    error("Error! connectorBase element with nil importBases list!", 2)
  elseif(p > #self.children)then
    error("Error! connectorBase element doesn't have a importBase child in position "..p.."!", 2)
  elseif(p > #self.importBases)then
    error("Error! connectorBase element doesn't have a importBase child in position "..p.."!", 2)
  end

  self:removeChild(self.importBases[p])
  table.remove(self.importBases, p)
end

function ConnectorBase:addCausalConnector(causalConnector)
  if((type(causalConnector) == "table"
    and causalConnector["getNameElem"] ~= nil
    and causalConnector:getNameElem() ~= "causalConnector")
    or (type(causalConnector) == "table"
    and causalConnector["getNameElem"] == nil)
    or type(causalConnector) ~= "table")then
    error("Error! Invalid causalConnector element!", 2)
  end

  self:addChild(causalConnector)
  table.insert(self.causalConnectors, causalConnector)
end

function ConnectorBase:getCausalConnectorPos(p)
  if(self.causalConnectors == nil)then
    error("Error! connectorBase element with nil causalConnectors list!", 2)
  elseif(p > #self.causalConnectors)then
    error("Error! connectorBase element doesn't have a causalConnector child in position "..p.."!", 2)
  end

  return self.causalConnectors[p]
end

function ConnectorBase:getCausalConnectorById(id)
  if(id == nil)then
    error("Error! id attribute of connectorbase element must be informed!", 2)
  elseif(self.causalConnectors == nil)then
    error("Error! connectorBase element with nil causalConnectors list!", 2)
  end

  for _, causalConnector in ipairs(self.causalConnectors) do
    if(causalConnector:getId() == id)then
      return causalConnector
    end
  end

  return nil
end

function ConnectorBase:setCausalConnectors(...)
  if(#arg>0)then
    for _, causalConnector in ipairs(arg) do
      self:addCausalConnector(causalConnector)
    end
  end
end

function ConnectorBase:removeCausalConnector(causalConnector)
  if((type(causalConnector) == "table"
    and causalConnector["getNameElem"] ~= nil
    and causalConnector:getNameElem() ~= "causalConnector")
    or (type(causalConnector) == "table"
    and causalConnector["getNameElem"] == nil)
    or type(causalConnector) ~= "table")then
    error("Error! Invalid causalConnector element!", 2)
  elseif(self.children == nil)then
    error("Error! connectorBase element with nil children list!", 2)
  elseif(self.causalConnectors == nil)then
    error("Error! connectorBase element with nil causalConnectors list!", 2)
  end

  self:removeChild(causalConnector)

  for p, cc in ipairs(self.causalConnectors) do
    if(causalConnector == cc)then
      table.remove(self.causalConnectors, p)
    end
  end
end

function ConnectorBase:removeCausalConnectorPos(p)
  if(self.children == nil)then
    error("Error! connectorBase element with nil children list!", 2)
  elseif(self.causalConnectors == nil)then
    error("Error! connectorBase element with nil causalConnectors list!", 2)
  elseif(p > #self.children)then
    error("Error! connectorBase element doesn't have a causalConnector child in position "..p.."!", 2)
  elseif(p > #self.causalConnectors)then
    error("Error! connectorBase element doesn't have a causalConnector child in position "..p.."!", 2)
  end

  self:removeChild(self.causalConnectors[p])
  table.remove(self.causalConnectors, p)
end

return ConnectorBase