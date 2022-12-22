-- REFRENCES: https://docs.rs/reqwest/latest/reqwest/struct.Response.html

--- Client
-- Dependencies: @{requests.status}
-- @classmod requests.Response
-- @pragma nostrip

-- pub fn remote_addr(&self) -> Option<SocketAddr>
--- Get the remote address used to get this Response.

local status = require("requests.status")

string.startswith = function(self, sub)
    -- return self:sub(1, string.len(sub) == sub
    return self:find("^" .. sub) ~= nil
end

Response = {}

function Response:new(response)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.headers = response.headers
    self.status_code = response.status_code
    self.url = response.url
    self._http_status = response.http_status
    self._sink = response.sink
    return o
end

--- Get the full response body as Bytes.
function Response:bytes()
    return table.concat(self._sink)
end

-- Retrieve the cookies contained in the response.
-- Note that invalid ‘Set-Cookie’ headers will be ignored.
function Response:cookies()
    local cookies = self.headers["cookies"] or self.headers["Cookies"]
    -- TODO cookies
end

--- Get the content-length of this response, if known.
-- Reasons it may not be known:
-- The server didn’t send a content-length header.
-- The response is compressed and automatically decoded (thus changing the actual decoded length).
function Response:content_length()
    local length = self.headers["content-length"] or self.headers["Content-Length"] or 0

    if type(length) == "string" then
        return tonumber(length)
    else
        return length
    end
end

-- Try to deserialize the response body as JSON.
function Response:json()
    local content_type = self.headers["content-type"] or self.headers["Content-Type"] or "unknown"

    if not content_type:startswith("application/json") then
        error("cannot deserialize response as json because content-type is " .. content_type)
    end

    local ok, cjson = pcall(require, "cjson")

    if ok then
        return cjson.decode(self:text())
    end
    
    error("cannot deserialize json reponse without lua-cjson module")
end

--- Get the StatusCode of this Response.
function Response:status()
    return status.StatusCode:new(self.status_code)
end

--- Get the full response text.
function Response:text()
    return table.concat(self._sink)
end

--- Get the HTTP Version of this Response.
function Response:version()
    if self._http_status:startswith("HTTP/0.9") then
        return 0.9
    elseif self._http_status:startswith("HTTP/1.0") then
        return 1.0
    elseif self._http_status:startswith("HTTP/1.1") then
        return 1.1
    elseif self._http_status:startswith("HTTP/2") then
        return 2
    elseif self._http_status:startswith("HTTP/3") then
        return 3
    end

    return 0
end

return Response
