
local fx = {}

fx._fade = nil
fx._fadeID = nil

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

fx.reset = function()
    tween.reset(fx._fadeID)
    fx._fade = nil
    fx._fadeID = nil
end

fx.draw = function()
    if fx._fade then
        local color = {love.graphics.getColor()}
        love.graphics.setColor(fx._fade)
        love.graphics.rectangle('fill', 0, 0, love.window.getWidth(), love.window.getHeight())
        love.graphics.setColor(color)
    end

    if config.debug then
        local oldFont = love.graphics.getFont()
        love.graphics.setFont(font[16])
        local mouseX, mouseY = love.mouse.getPosition()
        love.graphics.print("FPS: "..love.timer.getFPS(), 5, 5)
        --love.graphics.print("Mouse: "..mouseX..", "..mouseY, 5, 45)
        love.graphics.setFont(oldFont)
    end
end

return fx