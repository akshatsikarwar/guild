local function main(event)
    local audit = db:table("audit")
    return audit:insert({t = db:now(), event = db:table_to_json(event)})
end
