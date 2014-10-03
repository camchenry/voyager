-- Function: searchTable
-- Returns the index of a value in a table. If the value
-- does not exist in the table, this returns nil.
--
-- Arguments:
--      table - table to search
--      search - value to search for
--
-- Returns:
--      integer index or nil

function searchTable (table, search)
    for i, value in ipairs(table) do
        if value == search then return i end
    end

    return nil
end

-- Function: shuffleTable
-- Shuffles the contents of a table in place.
-- via http://www.gammon.com.au/forum/?id=9908
--
-- Arguments:
--      src - table to shuffle
--
-- Returns:
--      table passed

function shuffleTable (src)
  local n = #src
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    src[n], src[k] = src[k], src[n]
    n = n - 1
  end
 
  return src
end

-- Function: dump
-- Returns a string representation of a variable in a way
-- that can be reconstituted via loadstring(). Yes, this
-- is basically a serialization function, but that's so much
-- to type :) This ignores any userdata, functions, or circular
-- references.
-- via http://www.lua.org/pil/12.1.2.html
--
-- Arguments:
--      source - variable to describe
--      ignore - a table of references to ignore (to avoid cycles),
--               defaults to empty table. This uses the references as keys,
--               *not* as values, to speed up lookup.
--
-- Returns:
--      string description

function dump (source, ignore)
    ignore = ignore or { source = true }
    local sourceType = type(source)
    
    if sourceType == 'table' then
        local result = '{ '

        for key, value in pairs(source) do
            if not ignore[value] then
                if type(value) == 'table' then
                    ignore[value] = true
                end

                local dumpValue = dump(value, ignore)

                if dumpValue ~= '' then
                    result = result .. '["' .. key .. '"] = ' .. dumpValue .. ', '
                end
            end
        end

        if result ~= '{ ' then
            return string.sub(result, 1, -3) .. ' }'
        else
            return '{}'
        end
    elseif sourceType == 'string' then
        return string.format('%q', source)
    elseif sourceType ~= 'userdata' and sourceType ~= 'function' then
        return tostring(source)
    else
        return ''
    end
end

-- Ellipse in general parametric form
-- (See http://en.wikipedia.org/wiki/Ellipse#General_parametric_form)
-- (Hat tip to IdahoEv: https://love2d.org/forums/viewtopic.php?f=4&t=2687)
--
-- The center of the ellipse is (x,y)
-- a and b are semi-major and semi-minor axes respectively
-- phi is the angle in radians between the x-axis and the major axis

function love.graphics.ellipse(mode, x, y, a, b, phi, points)
  phi = phi or 0
  points = points or 100
  if points <= 0 then points = 1 end

  local two_pi = math.pi*2
  local angle_shift = two_pi/points
  local theta = 0
  local sin_phi = math.sin(phi)
  local cos_phi = math.cos(phi)

  local coords = {}
  for i = 1, points do
    theta = theta + angle_shift
    coords[2*i-1] = x + a * math.cos(theta) * cos_phi
                      - b * math.sin(theta) * sin_phi
    coords[2*i] = y + a * math.cos(theta) * sin_phi
                    + b * math.sin(theta) * cos_phi
  end

  coords[2*points+1] = coords[1]
  coords[2*points+2] = coords[2]

  love.graphics.polygon(mode, coords)
end

function round(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

function table.random(t, associative)
  associative = associative or false
  if associative then
      local t2 = {}

      for k in pairs(t) do
          t2[#t2 + 1] = k
      end
      
      local key = table.random(t2)

      -- key, value
      return key, t[key]
  else
      local key = math.random(1, #t)

      -- key, value
      return key, t[key]
  end
end

-- see: https://love2d.org/forums/viewtopic.php?f=4&p=65969
function drawArc (x, y, r, s_ang, e_ang, numLines)
   numLines = numLines or 150
   local step = ((math.pi * 2) / numLines)
   local cos, sin, line = math.cos, math.sin, love.graphics.line

   local ang1 = s_ang
   local ang2 = 0
   
   while (ang1 < e_ang) do
      -- increment angle
      ang2 = ang1 + step

      -- draw a line from 'previous' angle to 'actual' angle
      line(x + (cos(ang1) * r), y - (sin(ang1) * r),
                         x + (cos(ang2) * r), y - (sin(ang2) * r))
      
                -- update 'previous' angle
      ang1 = ang2
   end

end

local stencilCache = {}
function filled_arc(cx, cy, radius, start, stop, segments)
    local stencil = nil

    if stencilCache[radius-love.graphics.getLineWidth()] == nil then
        stencil = function()
            love.graphics.circle('fill', 0, 0, radius-love.graphics.getLineWidth(), 64)
        end

        stencilCache[radius-love.graphics.getLineWidth()] = stencil
    else
        stencil = stencilCache[radius-love.graphics.getLineWidth()]
    end

    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.setInvertedStencil(stencil)
    love.graphics.scale(1, -1)
    love.graphics.arc('fill', 0, 0, radius, start, stop, segments)
    love.graphics.pop()
    love.graphics.setInvertedStencil(nil)
end