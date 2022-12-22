local Client = require("requests.Client")

local client = Client:new({cookies = true})

local response = client:get("https://httpbin.org/cookies/set/cookie1/baked1")
response = client:get("https://httpbin.org/cookies/set/cookie2/baked2")
response = client:get("https://httpbin.org/cookies", {
    cookies = { cookie3 = "baked3" }
})

print(response:text())
