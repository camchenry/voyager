
local fx = {}

wait = function(t, callback, ...) fx._wait = tween(t, {0}, {0}, nil, callback, ...); return fx._wait end

fx._fade = nil
fx._fadeID = nil

fx._text = nil
fx._textID = nil
fx._textAlpha = nil
fx._textColor = nil
fx._textFont = nil
fx._textX = 0
fx._textY = 0

fx.fade = function(t, color, easing, callback, ...)
    if fx._fadeID ~= nil then
        tween.reset(fx._fadeID)
    end

    local alpha = color[4] or 255
    fx._fade = color
    fx._fade[4] = 0

    fx._fadeID = tween(t, fx._fade, {color[1], color[2], color[3], alpha}, easing, callback, ...)
end

fx.flash = function(t, color, easing, callback, ...)
    if fx._fadeID ~= nil then
        tween.reset(fx._fadeID)
    end
    
    color[4] = color[4] or 255
    fx._fade = color

    fx._fadeID = tween(t, fx._fade, {color[1], color[2], color[3], 0}, easing, callback, ...)
end

fx.transition = function(t, to, ...)
    if fx._fade == nil then
        fx.fade(t, {0, 0, 0}, nil, function(to, ...)
            state.switch(to, ...)
            fx.flash(t, {0, 0, 0}, nil, fx.reset)
        end, to, ...)
    end
end

fx.text = function(delay, text, x, y, color, typeface, easing, callback, ...)
    if fx._textWait ~= nil then
        tween.reset(fx._textWait)
        fx._textAlpha = 0
        fx._text = nil
    end

    fx._text = text
    fx._textFont = typeface or font[28]
    fx._textColor = color or {255, 255, 255}
    fx._textX = x or 0
    fx._textY = y or 0
    fx._textAlpha = 255

    fx._textWait = wait(delay, function(...)
        fx._textAlpha = 0
    end, ...)
end

fx.fadeText = function(t, delay, text, x, y, color, typeface, easing, callback, ...)
    if fx._textWait ~= nil then
        tween.reset(fx._textWait)
        fx._textAlpha = 255
        fx._text = nil
    end

    fx._text = text
    fx._textFont = typeface or font[28]
    fx._textColor = color or {255, 255, 255}
    fx._textX = x or 0
    fx._textY = y or 0
    fx._textAlpha = 0

    fx._textID = tween(t, fx, {_textAlpha = 255}, easing, function(...)
        fx._textWait = wait(delay, function(...)
            fx._textID = tween(t, fx, {_textAlpha = 0}, easing, callback, ...)
        end, ...)
    end, ...)
end

fx.reset = function()
    tween.reset(fx._fadeID)
    tween.reset(fx._fadeText)
    tween.resetAll()
    fx._fade = nil
    fx._fadeID = nil

    fx._text = nil
    fx._textID = nil
    fx._textAlpha = nil
    fx._textColor = nil
    fx._textFont = nil
    fx._textX = 0
    fx._textY = 0
end

fx.draw = function()
    if fx._fade then
        local color = {love.graphics.getColor()}
        love.graphics.setColor(fx._fade)
        love.graphics.rectangle('fill', 0, 0, love.window.getWidth(), love.window.getHeight())
        love.graphics.setColor(color)
    end

    if fx._text then
        local color = {love.graphics.getColor()}
        local font = love.graphics.getFont()
        love.graphics.setColor(fx._textColor[1], fx._textColor[2], fx._textColor[3], fx._textAlpha)
        love.graphics.setFont(fx._textFont)
        love.graphics.print(fx._text, fx._textX, fx._textY)
        
        love.graphics.setColor(color)
        love.graphics.setFont(font)
    end
end

return fx