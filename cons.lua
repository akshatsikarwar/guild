local function main()
    db:column_name('event', 1)
    local hndl =  db:consumer()
    local event = hndl:get()
    while event do
        event.id = nil
        local json = db:table_to_json(event)
        hndl:emit(json)
        hndl:consume()
        event = hndl:get()
    end
end
