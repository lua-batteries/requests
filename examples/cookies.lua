local Client = require("requests.Client")
local cookie = require("requests.cookie")

-- Container of default cookies.
local jar = cookie.Jar:new()
jar:add_cookie_str("cookie4=pre-baked; Path=/cookies", "https://httpbin.org")

local client = Client:new({
    cookie_store = true,
    cookie_provider = jar, -- Baked cookies
})

local response

-- Bake some cookies.
response = client:get("https://httpbin.org/cookies/set/cookie1/baked1")

-- cookies() method returns list of cookies set by this request.
local set_cookies = response:cookies()
assert(set_cookies[1]["name"] == "cookie1")
assert(set_cookies[1]["value"] == "baked1")
assert(set_cookies[1]["domain"] == nil) -- Client will use httpbin.org as domain in this case.

response = client:get("https://httpbin.org/cookies/set/cookie2/baked2")

response = client:get("https://httpbin.org/cookies", {
    -- Add cookie3 for this request.
    -- For more complex cookies use cookie.Jar
    cookies = { cookie3 = "baked3" }
})

print(response:text())

-- Now cookie3 will be removed.
response = client:get("https://httpbin.org/cookies")

print(response:text())
