-- Function to create a backlink
local function createBacklink(citationId)
    if citationId then
        return pandoc.RawInline("html", 
            string.format('<a href="#cite-%s">↩</a>', citationId))
    end
    return pandoc.RawInline("html", '<a href="#">↩</a>')
end

-- Handle citations
function Cite(cite)
    if cite and cite.citations then
        for _, citation in ipairs(cite.citations) do
            if citation.id then
                -- Add an HTML anchor
                local anchor = pandoc.RawInline("html", 
                    string.format('<span id="cite-%s"></span>', citation.id))
                table.insert(cite.content, 1, anchor)
            end
        end
    end
    return cite
end

-- Process reference entries
function Div(el)
    if el.identifier == "refs" then
        for _, ref in ipairs(el.content) do
            if ref.t == "Div" and ref.identifier then
                local citationId = ref.identifier:match("ref%-(.+)")
                if citationId then
                    -- Find the last element to append the backlink
                    local lastElem = ref.content[#ref.content]
                    if lastElem and (lastElem.t == "Para" or lastElem.t == "Plain") then
                        table.insert(lastElem.content, createBacklink(citationId))
                    end
                end
            end
        end
    end
    return el
end