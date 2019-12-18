module test_calendars_times

using Test
using Calendars.Times

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

end # module test_calendars_times
