function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function randomPick(tbl)
    local i = math.random(#tbl)
    return tbl[i]
end
