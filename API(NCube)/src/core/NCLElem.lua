local Class = require "oo/Class"
local Validator = require "valid/Validator"

local NCLElem = Class:createClass{
  nameElem = nil,
  parent = nil,
  children = nil,
  childrenMap = nil,
  assMap = nil,
  attributesTypeMap = nil,
  attributesStringValueMap = nil,
  symbols = nil,
  attributesSymbolMap = nil,
  ncl = nil
}

function NCLElem:extends()
  return Class:createClass(NCLElem)
end

function NCLElem:getNameElem()
  return self.nameElem
end

function NCLElem:setParent(parent)
  self.parent = parent
end

function NCLElem:getParent()
  return self.parent
end

function NCLElem:addChild(child, p)
  if(child == nil)then
    error("Error! Attempt to set a nil child to "..self.nameElem.."!", 2)
  elseif(child.nameElem == nil)then
    error("Error! Attempt to set a invalid child to "..self.nameElem.." because it is not a NCLElement!", 2)
  end

  local valid = false

  if(self.childrenMap == nil)then
    error("Error! "..self.nameElem.." with nil childrenMap list!", 2)
  end

  for chd, _ in pairs(self.childrenMap) do
    if(chd == child.nameElem)then
      valid = true
    end
  end

  if(not(valid))then
    error("Error! Attempt to set a invalid child! "..child.nameElem.." cannot be child of "..self.nameElem.."!", 2)
  end

  if(p ~= nil)then
    table.insert(self.children, p, child)
  else
    table.insert(self.children, child)
  end

  child:setParent(self)
end

function NCLElem:getChild(p)
  if(self.children == nil)then
    error("Error! "..self.nameElem.." with nil children list!", 2)
  elseif(p > #self.children)then
    error("Error! "..self.nameElem.." element doesn't have a child in position "..p.."!", 2)
  end

  return self.children[p]
end

function NCLElem:getPosChild(child)
  if(child == nil)then
    error("Error! Nil is not a valid child to "..self.nameElem.."!", 2)
  elseif(child.nameElem == nil)then
    error("Error! Invalid child! It is not a NCLElement! Cannot be child of "..self.nameElem.."!", 2)
  elseif(self.children == nil)then
    error("Error! "..self.nameElem.." with nil children list!", 2)
  end

  for p, chd in ipairs(self.children) do
    if(chd == child)then
      return p
    end
  end

  return nil
end

function NCLElem:getLastPosChild(child)
  if(child == nil)then
    error("Error! Nil is not a valid child to "..self.nameElem.."!", 2)
  elseif(self.children == nil)then
    error("Error! "..self.nameElem.." with nil children list!", 2)
  end

  local p

  for i, chd in ipairs(self.children) do
    if(child == chd.nameElem)then
      p = i
    end
  end

  return p
end

function NCLElem:getPosAvailable(...)
  for _, elem in ipairs(arg) do
    local p = self:getLastPosChild(elem)
    if(p ~= nil)then
      return p + 1
    end
  end
end

function NCLElem:removeChildPos(p)
  if(self.children == nil)then
    error("Error! Attempt to remove failed! "..self.nameElem.." with nil children list!", 2)
  elseif(p > #self.children)then
    error("Error! Attempt to remove failed! "..self.nameElem.." element doesn't have a child in position "..p.."!", 2)
  end

  self:getChild(p):setParent(nil)
  table.remove(self.children, p)
end

function NCLElem:removeChild(child)
  local p = self:getPosChild(child)

  if(p == nil)then
    error("Error! Attempt to remove failed! "..self.nameElem.." element doesn't have this child!", 2)
  end

  self:removeChildPos(p)
end

function NCLElem:setChildren(...)
  if(#arg > 0)then
    for _, child in ipairs(arg) do
      self:addChild(child)
    end
  end
end

function NCLElem:getChildren()
  return self.children
end

function NCLElem:removeAllChildren()
  if(self.children == nil)then
    error("Error!  Attempt to remove failed! "..self.nameElem.." with nil children list!", 2)
  end

  for _, child in ipairs(self.children) do
    child:setParent(nil)
  end

  self.children = {}
end

function NCLElem:getChildrenMap()
  return self.childrenMap
end

function NCLElem:getAssMap()
  return self.assMap
end

function NCLElem:getDescendants()
  local descendants = {}

  local children = self.children

  if(children ~= nil)then
    local nchildren = #children

    local descs = nil

    for i=1,nchildren do
      local child = self.children[i]
      table.insert(descendants, child)

      descs = child:getDescendants()
      for _, desc in ipairs(descs) do
        table.insert(descendants, desc)
      end
    end
  end

  return descendants
end

function NCLElem:getDescendantByAttribute(attribute, value)
  local descs = self:getDescendants()
  local targetDescs = {}

  for _, desc in ipairs(descs) do
    if(desc.attributesTypeMap ~= nil and desc.attributesTypeMap[attribute] ~= nil
      and desc:getAttribute(attribute) == value)then
      table.insert(targetDescs, desc)
    end
  end

  if(#targetDescs == 1)then
    return targetDescs[1]
  elseif(#targetDescs > 2)then
    return targetDescs
  end

  return nil
end

function NCLElem:getInterface(interface)
  local descs = self:getDescendants()

  for _, desc in ipairs(descs) do
    if(desc.name ~= nil and desc.name == interface)then
      return desc
    end
  end

  return nil
end

function NCLElem:isValidAttributeType(attribute, value)
  if(self.attributesTypeMap ~= nil)then
    if(type(self.attributesTypeMap[attribute]) == "table")then
      for _, typeAtt in ipairs(self.attributesTypeMap[attribute]) do
        if(typeAtt == type(value))then
          return true
        end
      end
    elseif(self.attributesTypeMap[attribute] == type(value))then
      return true
    end
  end

  return false
end

function NCLElem:isValidRangeStringType(attribute, value)
  if(self.attributesStringValueMap ~= nil
    and self.attributesStringValueMap[attribute] ~= nil)then
    if(type(self.attributesStringValueMap[attribute]) == "table")then
      for _, val in ipairs(self.attributesStringValueMap[attribute]) do
        if(val == value)then
          return true
        end
      end
    else
      return self.attributesStringValueMap[attribute] == value
    end
  else
    return true
  end
  return false
end

function NCLElem:addAttribute(attribute, value)
  if(Validator:isInvalidString(attribute))then
    error("Error! Nil, empty or invalid attribute informed in "..self.nameElem.." element! It must be a valid string!", 2)
  elseif(self.attributesTypeMap ~= nil and self.attributesTypeMap[attribute] == nil)then
    error("Error! "..attribute.." attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  elseif(value == nil)then
    error("Error! Nil value passed to "..attribute.." attribute in "..self.nameElem.." element!", 2)
  elseif(not self:isValidAttributeType(attribute, value))then
    error("Error! Type of "..attribute.." attribute is not valid to "..self.nameElem.." element!", 2)
  elseif(type(value) == "string" and string.find(value,  "%$") == nil and
    not self:isValidRangeStringType(attribute, value))then
    error("Error! Value "..value.." passed to "..attribute.." attribute is not a possible value in "..self.nameElem.." element!", 2)
  else
    self[attribute] = value
  end
end

function NCLElem:removeAttribute(attribute)
  if(Validator:isEmptyOrNil(attribute))then
    error("Error! Empty or nil attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  elseif(Validator:isInvalidString(attribute))then
    error("Error! "..attribute.." attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  elseif(self.attributesTypeMap ~= nil and self.attributesTypeMap[attribute] == nil)then
    error("Error! "..attribute.." attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  else
    self[attribute] = nil
  end
end

function NCLElem:getAttribute(attribute)
  if(Validator:isEmptyOrNil(attribute))then
    error("Error! Empty or nil attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  elseif(Validator:isInvalidString(attribute))then
    error("Error! "..attribute.." attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  elseif(self.attributesTypeMap ~= nil and self.attributesTypeMap[attribute] == nil)then
    error("Error! "..attribute.." attribute is not a valid attribute to "..self.nameElem.." element!", 2)
  else
    return self[attribute]
  end
end

function NCLElem:getAttributesTypeMap()
  return self.attributesTypeMap
end

function NCLElem:getAttributesStringValueMap()
  return self.attributesStringValueMap
end

function NCLElem:getSymbols()
  return self.symbols
end

function NCLElem:getSymbol(attribute)
  return self.symbols[attribute]
end

function NCLElem:getAttributesSymbolMap()
  return self.attributesSymbolMap
end

function NCLElem:isEmptyTable(attributes)
  if(type(attributes) == "table")then
    for _, _ in pairs(attributes) do
      return false
    end
  end

  return true
end

function NCLElem:setAttributes(attributes)
  if(attributes == nil
    or type(attributes) ~= "table"
    or self:isEmptyTable(attributes))then
    error("Error! Attributes must be informed to be defined!", 2)
  end

  for attribute, value in pairs(attributes) do
    self:addAttribute(attribute, value)
  end
end

function NCLElem:addSymbol(attribute, symbol)
  if(self.attributesSymbolMap == nil)then
    self.symbols[attribute] = symbol
    return
  end

  local isInvalidSymbol = false

  if(type(self.attributesSymbolMap[attribute]) == "table")then
    for _, sb in ipairs(self.attributesSymbolMap[attribute]) do
      if(symbol == sb)then
        isInvalidSymbol = false
        break
      end
    end
  else
    if(self.attributesSymbolMap[attribute] == symbol) then
      isInvalidSymbol = false
    end
  end

  if(isInvalidSymbol)then
    error("Error! "..attribute.." attribute cannot have "..symbol.." character in "..self.nameElem.." element!", 2)
  else
    self.symbols[attribute] = symbol
  end
end

function NCLElem:putAttributeSymbol(attribute, value)
  local sb

  if(self.attributesSymbolMap ~= nil and self.symbols ~= nil)then
    if(string.match(value, "(%d+)%.(%d+)") == nil and string.match(value, "(%d+)") == nil)then
      return
    end

    sb = string.match(value, "(%a+)")
    if(sb == nil and string.match(value, "(%%+)") ~= nil)then
      sb = "%"
    end

    local isInvalidSymbol = true

    if(sb ~= nil)then
      if(type(self.attributesSymbolMap[attribute]) == "table")then
        for _, symbol in ipairs(self.attributesSymbolMap[attribute]) do
          if(sb == symbol)then
            isInvalidSymbol = false
            break
          end
        end

      else
        if(self.attributesSymbolMap[attribute] == sb) then
          isInvalidSymbol = false
        end
      end

      if(isInvalidSymbol)then
        error("Error! "..attribute.." attribute cannot have "..sb.." character in "..self.nameElem.." element!", 2)
      end
    end

    self.symbols[attribute] = sb
  else
    return
  end
end

function NCLElem:canBeNumber(attribute)
  if(type(self.attributesTypeMap[attribute]) == "table")then
    for _, typeAtt in ipairs(self.attributesTypeMap[attribute]) do
      if(typeAtt == "number")then
        return true
      end
    end
  else
    return self.attributesTypeMap[attribute] == "number"
  end

  return false
end

function NCLElem:readAttributes()
  local s, e, t, u, r, v, w, z

  _, s = string.find(self.ncl, "<"..self.nameElem.." ")
  _, t = string.find(self.ncl, "<"..self.nameElem..">")
  e = string.find(self.ncl, ">")

  if(s ~= nil and t == nil and e ~= nil)then
    local attributes = string.sub(self.ncl,s,e-1)

    u, r = string.find(attributes, "%S+=")

    while (u ~= nil and r ~= nil) do
      local attribute = string.sub(attributes, u, r-1)
      v = string.find(attributes, "\"", u+1)
      w = string.find(attributes, "%S+=", v+1)
      z = string.find(attributes, "\"", v+1)

      if(v == nil or z == nil or (w ~= nil and w < z))then
        error("Error! Document with invalid syntax!", 2)
      end

      local value = string.sub(attributes, v+1,z-1)

      if(self:canBeNumber(attribute)
        and string.match(value, ":") == nil
        and string.match(value, ",") == nil
        and string.match(value, "%s") == nil)then
        self:putAttributeSymbol(attribute, value)

        if(string.match(value, "(%d+)%.(%d+)") ~= nil)then
          local pInt, pFrac = string.match(value, "(%d+)%.(%d+)")
          value = tonumber(pInt) + tonumber(pFrac)/(math.pow(10, string.len(pFrac)))
        elseif(string.match(value, "(%d+)") ~= nil)then
          value = tonumber(string.match(value, "(%d+)"))
        end
      elseif(self.attributesTypeMap[attribute] == "boolean" and value == "false")then
        value = false
      elseif(self.attributesTypeMap[attribute] == "boolean" and value == "true")then
        value = true
      end

      self:addAttribute(attribute, value)

      attributes = string.sub(attributes, z+1, string.len(attributes))
      u, r = string.find(attributes, "%S+=")
    end
  end
end

function NCLElem:readChildrenNcl()
  local s, t, u

  s = string.find(self.ncl,">")
  t = string.sub(self.ncl, 1, s)
  u = string.find(t,"/>")

  local childrenNcl

  if(u == nil)then
    local _, n = string.gsub(self.ncl, "</"..self.nameElem..">", "*")
    local e, v, w

    if(n > 1)then
      childrenNcl = self.ncl
      w, v = 0

      repeat
        e, v = string.find(self.ncl, "</"..self.nameElem..">", v)
        w = w + 1
      until w == n
    else
      e, v = string.find(self.ncl, "</"..self.nameElem..">")
    end

    childrenNcl = string.sub(self.ncl, s+1, e-1)
  end

  return childrenNcl
end

function NCLElem:readChildNcl(childrenNcl, childName)
  local s = string.find(childrenNcl, "<")
  local e = string.find(childrenNcl, ">")

  if(s == nil and e == nil)then
    error("Error! Document with invalid syntax!", 2)
  end

  local t = string.find(childrenNcl, "<", s+1)

  if(t ~= nil and e > t)then
    error("Error! Document with invalid syntax!", 2)
  end

  local aux1 = string.sub(childrenNcl, s, e)

  local v = string.find(aux1,"/>")

  if(v ~= nil)then
    return aux1, e
  else
    local _, u = string.find(childrenNcl, "</"..childName..">")

    if(u == nil)then
      error("Error! Document with invalid syntax!", 2)
    end

    while(1)do
      aux1 = string.sub(childrenNcl, s, u)

      local _, n1 = string.gsub(aux1, "<"..childName..">", "opening_tag")

      local n2 = 0
      local r, z = string.find(aux1, "<"..childName.." ")

      if(n1 == 0 and r == nil and z == nil)then
        error("Error! Document with invalid syntax!", 2)
      end

      while(r ~= nil and z ~= nil)do
        local y = string.find(aux1, ">", z)

        if(y == nil)then
          error("Error! Document with invalid syntax!", 2)
        end

        local aux2 = string.sub(aux1, r, y)

        if(string.find(aux2, "/>") == nil)then
          n2 = n2 + 1
        end

        r, z = string.find(aux1, "<"..childName.." ", y)
      end

      local nopening = n1 + n2
      local _, nclosing = string.gsub(aux1, "</"..childName..">", "closing_tag")

      if(nopening == nclosing)then
        local p = 1

        for i = 1,nclosing do
          _, p = string.find(childrenNcl , "</"..childName..">", p)
          p = p + 1
        end

        return string.sub(childrenNcl, s, p), p
      end

      _, u = string.find(childrenNcl, "</"..childName..">", u)

      if(u == nil)then
        error("Error! Document with invalid syntax!", 2)
      end
    end
  end
end

function NCLElem:ncl2Table()
  local s, e, t, u

  if(self:getNameElem() == "metadata")then
    _, s = string.find(self:getNcl(), "<metadata>")
    e = string.find(self:getNcl(), "</metadata>")

    if(s == nil or e == nil)then
      error("Error! Document with invalid syntax!", 2)
    end

    self:setRdfTree(string.sub(self:getNcl(), s+1, e-1))
    return
  end

  self:readAttributes()

  local childrenNcl = self:readChildrenNcl()
  if(childrenNcl ~= nil)then
    repeat
      t = string.find(childrenNcl, ">")
      u = string.sub(childrenNcl, 1, t)
      s, e = string.find(u, "<%a+")

      if(s == nil and e == nil)then
        error("Error! Document with invalid syntax!", 2)
      else
        local childName = string.sub(childrenNcl, s+1, e)
        local childNcl, h = self:readChildNcl(childrenNcl, childName)

        if(childNcl ~= nil)then
          if(self.childrenMap ~= nil)then
            local map = self.childrenMap[childName]

            if(map ~= nil)then
              local childClass = map[1]
              local childObject = childClass:create()

              childObject:setNcl(childNcl)
              childObject:ncl2Table()
              self:addChild(childObject)

              local cardinality = map[2]

              if(cardinality == "many")then
                if(self[childName..'s'] == nil)then
                  self[childName..'s'] = {}
                end

                table.insert(self[childName.."s"], childObject)
              elseif(cardinality == "one")then
                self[childName] = childObject
              end
            else
              error("Error! Document with invalid syntax!", 2)
            end
          end
        end

        if(h ~= nil)then
          childrenNcl = string.sub(childrenNcl, h+1, string.len(childrenNcl))
        end
      end

    until (string.find(childrenNcl, "%a") == nil)
  end
end

function NCLElem:table2Ncl(deep)
  local ncl = ""

  if(deep == 0 and self.nameElem == "ncl")then
    if(self:getXmlHead() ~= nil and self:getXmlHead() ~= "")then
      ncl = ncl..self:getXmlHead().."\n".."<!--Generated by NCube-->\n"
    end
  else
    for i=1,deep do
      ncl = ncl.." "
    end
  end

  if(self.nameElem == "metadata")then
    ncl = ncl.."<metadata>\n"

    if(self:getRdfTree() ~= nil and self:getRdfTree() ~= "")then
      ncl = ncl..self:getRdfTree()
    end

    for i=1,deep do
      ncl = ncl.." "
    end

    return ncl.."</metadata>\n"
  end

  ncl = ncl.."<"..self.nameElem

  if(self.attributesTypeMap ~= nil)then
    for attribute, _ in pairs(self.attributesTypeMap) do
      if(self[attribute] ~= nil)then
        if(self.symbols ~= nil and self.symbols[attribute] ~= nil)then
          ncl = ncl.." "..attribute.."=\""..self[attribute]..self.symbols[attribute].."\""
        else
          ncl = ncl.." "..attribute.."=\""..tostring(self[attribute]).."\""
        end
      end
    end
  end

  local children = self.children

  if(children ~= nil)then
    local nchildren = #children

    if(nchildren == 0)then
      return ncl.."/>\n"
    end

    if(children ~= nil)then
      ncl = ncl..">\n"
      for i=1,nchildren do
        local child = self.children[i]
        ncl = ncl..child:table2Ncl(deep+1)
      end

      for i=1,deep do
        ncl = ncl.." "
      end
    end
  else
    return ncl.."/>\n"
  end

  if(self.nameElem == "ncl")then
    return ncl.."</"..self.nameElem..">"
  else
    return ncl.."</"..self.nameElem..">\n"
  end
end

function NCLElem:setNcl(ncl)
  self.ncl = ncl
end

function NCLElem:getNcl()
  return self.ncl
end

function NCLElem:buildNcl()
  self.ncl = self:table2Ncl(0)
end

function NCLElem:writeNcl()
  self:buildNcl()
  print(self.ncl)
end

return NCLElem
