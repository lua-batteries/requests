local Client = require("requests.Client")
local cookie = require("requests.cookie")

local jar = cookie.Jar:new()
jar:add_cookie_str("cookie4=pre-baked; Path=/cookies", "https://httpbin.org")

local client = Client:new({
    cookie_store = true,
    cookie_provider = jar, -- Baked cookies
})

local response

-- Bake some cookies
response = client:get("https://httpbin.org/cookies/set/cookie1/baked1")
response = client:get("https://httpbin.org/cookies/set/cookie2/baked2")

response = client:get("https://httpbin.org/cookies", {
    -- Add cookie3 for this request.
    -- For more complex cookies use cookie.Jar
    cookies = { cookie3 = "baked3" }
})

print(response:text())

-- Now cookie3 will be removed
response = client:get("https://httpbin.org/cookies")

print(response:text())
