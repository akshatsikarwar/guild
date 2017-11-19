local function main(event)
    event.id = nil
    local audit = db:table("audit")
    local json = db:table_to_json(event)
    return audit:insert({t = db:now(), event = json})
end
