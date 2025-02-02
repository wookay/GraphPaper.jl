# module Calendars

function Base.show(io::IO, cal::HorizontalCalendar)
    monday = firstdayofweek(cal.startDate)
    firstweekdayoffset = getfirstweekdayoffset(monday, cal.firstweekday)
    thedayfirstweekday = monday + Day(firstweekdayoffset)
    if cal.startDate - thedayfirstweekday >= Week(1)
        thedayfirstweekday += Week(1)
    end
    grid = mapfoldl(vcat, collect(thedayfirstweekday:Week(1):cal.endDate), init=Array{Date, 2}(undef, 0, 7)) do weekday
        reshape(weekday:Day(1):(weekday + Day(6)), (1, 7))
    end
    td_dict = Dict{Int,Union{Int,AbstractString}}()
    dayabbrs = circshift(dayabbrshort.(Dates.Mon:Dates.Sun; locale=cal.locale), -firstweekdayoffset)
    daysofweek = Dict(map(1:7) do nth
        (nth, dayabbrs[nth])
    end)
    (rows, cols) = size(grid)
    for row in 1:rows
        nth = findfirst(d -> day(d) == 1, grid[row, :])
        if nth !== nothing
            firstday = grid[row, :][nth]
            if cal.startDate <= firstday <= cal.endDate
                m = monthabbr(month(firstday), locale=cal.locale)
                td_dict[row] = m
                td_dict[row+1] = year(firstday)
            end
        end
    end
    if isempty(td_dict)
        firstday = cal.startDate
        m = monthabbr(month(firstday), locale=cal.locale)
        row = 1
        td_dict[row] = m
        td_dict[row+1] = year(firstday)
    end

    leftside = 4
    print(io, repeat(' ', leftside))
    print(io, ' ')
    print(io, join(map(1:cols) do col
        haskey(daysofweek, col) ? daysofweek[col] : repeat(' ', 2)
    end, ' '))
    println(io)

    prev_year = nothing
    colormap = Dict{Date,Union{Int,Symbol}}()
    for span in cal.datespans, date in span.dates
        colormap[date] = span.color
    end
    for row in 1:rows
        leftsidetext = repeat(' ', leftside)
        if haskey(td_dict, row)
            val = td_dict[row]
            if val isa Int && prev_year != val
                leftsidetext = rpad(val, leftside)
                prev_year = val
            elseif val isa AbstractString
                leftsidetext = string(val, repeat(' ', clamp(leftside - (textwidth(val)), 0, leftside)))
            end
        end
        print(io, leftsidetext)
        print(io, ' ')
        days = grid[row, :]
        len = length(days)
        for (idx, d) in enumerate(days)
            if cal.startDate <= d <= cal.endDate
                str = lpad((string ∘ day)(d), cal.cell.size[1], ' ')
                if haskey(colormap, d)
                    printstyled(io, str, color=colormap[d])
                else
                    print(io, str)
                end
            else
                print(io, repeat(' ', cal.cell.size[1]))
            end
            idx < len && print(io, repeat(' ', cal.cell.margin[1]))
        end
        row < rows && println(io)
    end
end

# module Calendars
