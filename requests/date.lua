--[[

    REFRENCES
    ---------

    1. https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date
    2. https://stackoverflow.com/questions/4105012/convert-a-string-date-to-a-timestamp
    3. https://docs.rs/reqwest/latest/reqwest/cookie/struct.Cookie.html
    4. https://docs.rs/reqwest/latest/reqwest/cookie/struct.Jar.html
    5. https://requests.readthedocs.io/en/latest/user/quickstart/#cookies
    6. https://docs.python.org/3/library/http.cookiejar.html

]] --

date = {}

function date.parse(date_str)
    assert(
        type(date_str) == "string",
        string.format("bad argument #1 to 'date_str' (string expected, got %s)", type(date_str))
    )

    local pdate = {}
    pdate.day, pdate.month, pdate.year, pdate.hour, pdate.min, pdate.sec = date_str:match("%a+, (%d+).(%a+).(%d+) (%d+):(%d+):(%d+) GMT")

    if pdate.day == nil then
        error(string.format("couldn't parse 'day' for given date '%s'", date_str))
    end

    if pdate.month == nil then
        error(string.format("couldn't parse 'month' for given date '%s'", date_str))
    end

    if pdate.year == nil then
        error(string.format("couldn't parse 'year' for given date '%s'", date_str))
    end

    if pdate.hour == nil then
        error(string.format("couldn't parse 'hour' for given date '%s'", date_str))
    end

    if pdate.min == nil then
        error(string.format("couldn't parse 'min' for given date '%s'", date_str))
    end

    if pdate.sec == nil then
        error(string.format("couldn't parse 'sec' for given date '%s'", date_str))
    end

    local months = {
        Jan = 1,
        Feb = 2,
        Mar = 3,
        Apr = 4,
        May = 5,
        Jun = 6,
        Jul = 7,
        Aug = 8,
        Sep = 9,
        Oct = 10,
        Nov = 11,
        Dec = 12,
    }
    pdate.month = months[pdate.month]

    return os.time(pdate) + (os.time() - os.time(os.date("!*t")))
end

function date.is_expired(time)
    assert(
        type(time) == "string" or type(time) == "number",
        string.format("bad argument #1 to 'time' (string|number expected, got %s)", type(time))
    )

    if type(time) == "string" then
        time = date.parse(time)
    end

    return 0 >= os.difftime(time, os.time())
end

return date
