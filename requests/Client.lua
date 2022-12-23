-- REFRENCES: https://docs.rs/reqwest/latest/reqwest/struct.ClientBuilder.html

--- HTTP/1.1 Client
--
-- The @{Client} has various configuration values to tweak, but the defaults are set to what is usually the most commonly desired value. To configure a Client, use Client::builder().
-- The @{Client} holds a connection pool internally, so it is advised that you create one and reuse it.
-- @classmod requests.Client

local socket = require('socket')
local socket_url = require('socket.url')
local http = require('socket.http')
local ltn12 = require('ltn12')
local Response = require("requests.response")

string.split = function(self, sep)
    local splitted = {}
    for sub_str in self:gmatch("([^" .. sep .. "]+)") do
        table.insert(splitted, sub_str)
    end
    return splitted
end

local function format_queries(url, queries)
    assert(type(url) == "string", "url should be string")
    assert(type(queries) == "table", "request queries should be table")

    local final_url = url
    local first_query = false

    if #url:split("?") == 1 then
        first_query = true
    end

    for key, value in pairs(queries) do
        if type(value) == "table" then
            value = table.concat(value, ",")
        end

        if first_query then
            final_url = final_url .. "?" .. tostring(key) .. "=" .. tostring(value)
            first_query = false
        else
            if final_url:sub(-1) == "&" then
                final_url = final_url .. tostring(key) .. "=" .. tostring(value)
            else
                final_url = final_url .. "&" .. tostring(key) .. "=" .. tostring(value)
            end
        end
    end

    return final_url
end


--[[--
@{Client} custom configuration options.

@tfield table default_headers The default headers for every request.
@tfield string user_agent The User-Agent header to be used by this client.

@tfield boolean gzip Enable auto gzip decompression by checking the Content-Encoding response header.

If auto gzip decompression is turned on:

1. When sending a request and if the request’s headers do not already contain an Accept-Encoding and Range values, the Accept-Encoding header is set to gzip. The request body is not automatically compressed.

2. When receiving a response, if its headers contain a Content-Encoding value of gzip, both Content-Encoding and Content-Length are removed from the headers’ set. The response body is automatically decompressed.

@tfield boolean brotli Enable auto brotli decompression by checking the Content-Encoding response header.

If auto brotli decompression is turned on:

1. When sending a request and if the request’s headers do not already contain an Accept-Encoding and Range values, the Accept-Encoding header is set to br. The request body is not automatically compressed.

2. When receiving a response, if its headers contain a Content-Encoding value of br, both Content-Encoding and Content-Length are removed from the headers’ set. The response body is automatically decompressed.

@tfield boolean deflate Enable auto deflate decompression by checking the Content-Encoding response header.

If auto deflate decompression is turned on:

1. When sending a request and if the request’s headers do not already contain an Accept-Encoding and Range values, the Accept-Encoding header is set to deflate. The request body is not automatically compressed.

2. When receiving a response, if it’s headers contain a Content-Encoding value that equals to deflate, both values Content-Encoding and Content-Length are removed from the headers’ set. The response body is automatically decompressed.

@tfield boolean redirect Set a RedirectPolicy for this client.

Default will follow redirects up to a maximum of 10.

@tfield boolean Enable or disable automatic setting of the Referer header.

Default is true.
]]
Client = {
    default_headers = {},
    gzip = false,
    brotli = false,
    deflate = false,
    redirect = true,    
    referer = true,
    cookie_store = false,
    cookie_provider = {},
}

--- Create request client with custom configuration table.
-- @tparam[opt] Client.Client kwargs
-- @return @{Client}
function Client:new(kwargs)
    kwargs = kwargs or {}
    setmetatable(kwargs, self)
    self.__index = self

    if kwargs.default_headers then
        for key, value in pairs(kwargs.default_headers) do
            self.default_headers[key] = value
        end
    end

    if kwargs.user_agent then
        self.default_headers["user-agent"] = kwargs.user_agent
    end

    if kwargs.gzip then
        self.gzip = true
    end

    if kwargs.brotli then
        self.brotli = true
    end

    if kwargs.deflate then
        self.deflate = true
    end

    if not kwargs.redirect then
        self.redirect = false
    end

    if not kwargs.referer then
        self.referer = false
    end
    
    if kwargs.cookie_store then
        self.cookie_store = true
    end

    if kwargs.cookie_provider then
        assert(type(kwargs.cookie_provider) == "table", "cookie provider should be a table")

        for host_name, cookies in pairs(kwargs.cookie_provider) do
            for key, value in pairs(cookies) do
                local host_cookies = ""

                if host_cookies == "" then
                    host_cookies = tostring(key) .. "=" .. tostring(value)
                else
                    host_cookies = host_cookies .. "; " .. tostring(key) .. "=" .. tostring(value)
                end

                self.cookie_provider[host_name] = host_cookies
            end
        end
    end

    -- self.tcp = socket.tcp()
    -- self.tcp:setoption('keepalive', true)
    -- self.tcp:setoption('reuseaddr', true)
    return kwargs
end

--- Convenience method to make a GET request to a URL.
function Client:get(url, kwargs)
    return Client:request("GET", url, kwargs)
end

--- Convenience method to make a POST request to a URL.
function Client:post(url, kwargs)
    return Client:request("POST", url, kwargs)
end

--- Convenience method to make a PUT request to a URL.
function Client:put(url, kwargs)
    return Client:request("PUT", url, kwargs)
end

--- Convenience method to make a DELETE request to a URL.
function Client:delete(url, kwargs)
    return Client:request("DELETE", url, kwargs)
end

--- Convenience method to make a HEAD request to a URL.
function Client:head(url, kwargs)
    return Client:request("HEAD", url, kwargs)
end

-- function Client:options(url, args)
--     return Client:request("OPTIONS", url, args)
-- end

-- function Client:connect(url, args)
--     return Client:request("CONNECT", url, args)
-- end

--- Convenience method to make a PATCH request to a URL.
function Client:patch(url, kwargs)
    return Client:request("PATCH", url, kwargs)
end

-- function Client:trace(url, args)
--     return Client:request("TRACE", url, args)
-- end

-- https://docs.rs/reqwest/latest/reqwest/struct.RequestBuilder.html
--- Start building a Request with the Method and Url.
function Client:request(method, url, kwargs)
    kwargs = kwargs or {}
    assert(type(url) == "string",  "url should be string")
    assert(type(kwargs) == "table", "requests options should be a table")

    local host_name = socket_url.parse(url).host
    local request_headers = {}
    
    -- Shallow Copy
    for key, value in pairs(self.default_headers) do
        request_headers[key] = value
    end

    local stored_cookies = self.cookie_provider[host_name]

    if stored_cookies then
        request_headers["cookie"] = stored_cookies
    end

    if kwargs.cookies then
        assert(type(kwargs.cookies) == "table", "requests cookies should be a table")
        local cookies = ""

        for key, value in pairs(kwargs.cookies) do
            if cookies == "" then
                cookies = tostring(key) .. "=" .. tostring(value)
            else
                cookies = cookies .. "; " .. tostring(key) .. "=" .. tostring(value)
            end
        end

        local stored_cookies = request_headers["cookie"] or request_headers["Cookie"]

        if stored_cookies then
            if stored_cookies:sub(-1) == ";" then
                request_headers["cookie"] = stored_cookies .. " " .. cookies
            else
                request_headers["cookie"] = stored_cookies .. "; " .. cookies
            end
        else
            request_headers["cookie"] = cookies
        end
    end

    if self.referer then
        if self._refer_url then
            request_headers["referer"] = self._refer_url
        end
        
        self._refer_url = url
    end

    if kwargs.queries then
        url = format_queries(url, kwargs.queries)
    end

    local response = { sink = {}, url = url }

    local request_params = {
        method = method,
        url = url,
        headers = request_headers,
        sink = ltn12.sink.table(response.sink),
        redirect = self.redirect,
        -- create = function (nreqt)
        --     return self.tcp
        -- end,
        -- proxy = self.proxy
    }

    local ok
    ok, response.status_code, response.headers, response.http_status = http.request(request_params)

    if ok == 1 then
        if self.cookie_store then
            local cookies = response.headers["set-cookie"] or response.headers["Set-Cookie"]

            if cookies then
                local stored_cookies = self.cookie_provider[host_name]

                if stored_cookies then
                    if stored_cookies:sub(-1) == ";" then
                        self.cookie_provider[host_name] = stored_cookies .. " " .. cookies
                    else
                        self.cookie_provider[host_name] = stored_cookies .. "; " .. cookies
                    end
                else
                    self.cookie_provider[host_name] = cookies
                end
            end
        end

        return Response:new(response)
    end

    error(method .. " request to " .. response.url .. " failed because " .. response.status_code)
end

return Client
