--- HTTP/1.1 client
-- @module requests

local Client = require("requests.Client")

return {
    Client = Client,

    header = require("requests.header"),
    status = require("requests.status"),
    
    --- Convenience method to make a GET request to a URL.
    get = function (url)
        return Client:new():get(url)
    end
}
