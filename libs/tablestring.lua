local defaultSep = " "

-- Converts from a string to a table
-- Source: http://www.techques.com/question/1-1426954/Split-string-in-lua
function stringToTable(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
    end
    return t
end

-- Takes a table and writes it into a file as a string
function tableToString(dataTable, sep)
    if sep == nil then
        sep = defaultSep
    end
    
    local Text = ""
    for i = 1, #dataTable do
        if i == #dataTable then
            Text = Text..dataTable[i]
        else
            Text = Text..dataTable[i]..sep
        end
    end
    
    return Text
    --love.filesystem.write("data.txt", Text)
end

function toggle(var)
    if var then
        return false
    else
        return true
    end
end