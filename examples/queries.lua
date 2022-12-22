local Client = require("requests.Client")

local client = Client:new()

local response = client:get("https://httpbin.org/response-headers?key4=val4&", {
    queries = { key1 = "val1", key2 = "val2", key3 = {"val1", "val2"} }
})

print(response:text())
print(response.url)
