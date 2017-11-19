local function main(event)
    event.id = nil
    local audit = db:table("audit")
    return audit:insert({t = db:now(), event = db:table_to_json(event)})
end
