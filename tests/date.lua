local date = require("requests.date")

local test_date = "Tue, 27 Dec 2022 05:39:21 GMT"
local test_time = 1672119561

print("fn requests.date.parse")
assert(date.parse(test_date) == test_time)
assert(date.parse(test_date) == test_time)

print("fn requests.date.is_expired")
assert(date.is_expired(test_time) == true)
assert(date.is_expired("Tue, 27 Dec 2050 05:39:21 GMT") == false)
