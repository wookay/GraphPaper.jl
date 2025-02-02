module test_calendars_times

using Test
using Calendars.Times
using Dates

@test (Hour(1) + Minute(30)) == Hour(1.5)
@test (Minute(1) + Second(30)) == Minute(1.5)
@test (Second(1) + Millisecond(500)) == Second(1.5)

@test (Hour(1) + Minute(30) + Second(1) + Millisecond(500)) == Hour(1.5) + Second(1.5)
@test Day(0.5) + Hour(0.5) + Minute(0.5) == Hour(12) + Minute(30) + Second(30)

@test Hour(1) == Hour(1.0)
@test Minute(1) == Minute(1.0)
@test Second(1) == (Hour(0) + Second(1)) == Second(1.0)

@test (Day(1) + Hour(1) + Minute(30)) == Hour(25.5)
@test Day(0.5) == Hour(12)
@test Day(25) == Day(24.5) + Hour(12)

@test Minute(1) < Minute(1) + Second(2)
@test Minute(1) + Second(1) < Minute(1) + Second(2)

@test Hour(1//2) == Hour(0.5) == Minute(30)
@test Hour(2//2) == Hour(3//3) == Minute(60)

@test Hour(1/32) == Minute(1) + Second(52) + Millisecond(500)

@test Week(1) + Day(1) > Day(3)
@test Week(1) + Day(1) == Day(8)
@test Week(1) + Day(10) < Week(9)

@test Millisecond(1_000) == Second(1)
@test Nanosecond(1_000_000) == Microsecond(1_000) == Millisecond(1)

@test millisecond2datetime(1566724237000) == DateTime("2019-08-25T09:10:37")
@test datetime2millisecond(DateTime("2019-08-25T09:10:37")) == 1566724237000

end # module test_calendars_times
