local function emit_schema(tbl)
    local stmt, row
    stmt = db:prepare("select count(*) as num from comdb2_columns where tablename=?")
    stmt:bind(1, tbl)
    row = stmt:fetch()
    db:num_columns(row.num + 2)

    db:column_type("text", 1)
    db:column_name("event", 1)

    db:column_type("text", 2)
    db:column_name("type", 2)

    stmt = db:prepare("select columnname, type from comdb2_columns where tablename=?")
    stmt:bind(1, tbl)
    row = stmt:fetch()
    local i = 2
    while row do
        i = i + 1
        db:column_type(tostring(row.type), i)
        db:column_name(tostring(row.columnname), i)
        row = stmt:fetch()
    end
end
local function main(tbl)
    if tbl == nil then return -200, "missing tblname" end
    emit_schema(tbl)
    local hndl =  db:consumer()
    local event = hndl:get()
    while event do
        if event.old then
            event.old.type = "old"
            event.old.event = event.type
            hndl:emit(event.old)
        end
        if event.new then
            event.new.type = "new"
            event.new.event = event.type
            hndl:emit(event.new)
        end
        hndl:consume()
        event = hndl:get()
    end
end
