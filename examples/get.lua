local Client = require("requests.Client")

local client = Client:new()

local response = client:get("https://httpbin.org/get")
assert(response:status():is_success(), "request failed with " .. response.status_code)

print(response:text())

-- local function pprint(...)
--     print(require("inspect")(...))
-- end
