local Client = require("requests.Client")

local client = Client:new({
    cookie_store = true,
    cookie_provider = {
        ["httpbin.org"] = { cookie4 = "pre-baked" },
    }
})

local response

-- Bake some cookies
response = client:get("https://httpbin.org/cookies/set/cookie1/baked1")
response = client:get("https://httpbin.org/cookies/set/cookie2/baked2")

response = client:get("https://httpbin.org/cookies", {
    cookies = { cookie3 = "baked3" } -- Add cookie3 for this request only
})

print(response:text())

-- Now cookie3 will be removed
response = client:get("https://httpbin.org/cookies")

print(response:text())
