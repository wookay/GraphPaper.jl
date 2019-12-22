module Times # Calendars

export Day, Hour, Minute, Second, Millisecond, Nanosecond
export DateTime, Date, Time, millisecond2datetime, datetime2millisecond

using Dates
using .Dates: CompoundPeriod

"""
         Times.Day(n::Union{Rational,AbstractFloat})::CompoundPeriod
"""
function Dates.Day(n::Union{Rational,AbstractFloat})::CompoundPeriod
    d = trunc(Int, n)
    h = Hour(24(n - d))
    h == Hour(24) ? Day(d + 1) : Day(d) + h
end

"""
         Times.Hour(n::Union{Rational,AbstractFloat})::CompoundPeriod
"""
function Dates.Hour(n::Union{Rational,AbstractFloat})::CompoundPeriod
    h = trunc(Int, n)
    m = Minute(60(n - h))
    m == Minute(60) ? Hour(h + 1) : Hour(h) + m
end

"""
         Times.Minute(n::Union{Rational,AbstractFloat})::CompoundPeriod
"""
function Dates.Minute(n::Union{Rational,AbstractFloat})::CompoundPeriod
    m = trunc(Int, n)
    s = Second(60(n - m))
    s == Second(60) ? Minute(m + 1) : Minute(m) + s
end

"""
         Times.Second(n::Union{Rational,AbstractFloat})::CompoundPeriod
"""
function Dates.Second(n::Union{Rational,AbstractFloat})::CompoundPeriod
    s = trunc(Int, n)
    ms = Millisecond(1000(n - s))
    ms == Millisecond(1000) ? Second(s + 1) : Second(s) + ms
end

"""
         Times.Millisecond(n::Union{Rational,AbstractFloat})::CompoundPeriod
"""
function Dates.Millisecond(n::Union{Rational,AbstractFloat})::CompoundPeriod
    ms = trunc(Int, n)
    ns = Nanosecond(round(Int, 1000_000(n - ms)))
    ns == Nanosecond(1000_000) ? Millisecond(ms+1) : Millisecond(ms) + ns
end

Dates.value(x::Dates.CompoundPeriod) = sum(Dates.value.(x.periods))
Base.isless(x::Union{Period,Dates.CompoundPeriod}, y::Union{Period,Dates.CompoundPeriod}) = isless(Dates.value(x), Dates.value(y))

"""
         millisecond2datetime(millisecond::Int64)::DateTime
"""
function millisecond2datetime(millisecond::Int64)::DateTime
    rata = Dates.UNIXEPOCH + millisecond
    return DateTime(Dates.UTM(rata))
end

"""
         datetime2millisecond(dt::DateTime)::Int64
"""
function datetime2millisecond(dt::DateTime)::Int64
    Dates.value(dt) - Dates.UNIXEPOCH
end

end # module Calendars.Times
