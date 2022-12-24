--[[

    REFRENCES
    ---------

    1. https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
    2. https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
    3. https://docs.rs/reqwest/latest/reqwest/cookie/struct.Cookie.html
    4. https://docs.rs/reqwest/latest/reqwest/cookie/struct.Jar.html
    5. https://requests.readthedocs.io/en/latest/user/quickstart/#cookies
    6. https://docs.python.org/3/library/http.cookiejar.html

]] --

local socket_url = require('socket.url')

string.split = function(self, sep)
    local splitted = {}
    for sub_str in self:gmatch("([^" .. sep .. "]+)") do
        table.insert(splitted, sub_str)
    end
    return splitted
end

cookie = {}

--- A single HTTP cookie.
-- @return {
--     name: string, -- required
--     value: string, -- required
--     domain: string,
--     expires: string,
--     http_only: boolean,
--     max_age: number,
--     path: string,
--     same_site_lax: boolean,
--     same_site_none: boolean,
--     same_site_strict: boolean,
--     secure: boolean,
-- }
function cookie.parse(cookie)
    assert(type(cookie) == "string", "cookie should be string")

    local parsed_cookie = {}

    for _, single_cookie in pairs(cookie:split("; ")) do
        local splitted_cookie = single_cookie:split("=")

        if #splitted_cookie == 0 then
            error("cannot parse cookie string")
        end

        local name = splitted_cookie[1]
        local value

        if #splitted_cookie == 2 then
            value = splitted_cookie[2]
        elseif #splitted_cookie >= 2 then
            value = single_cookie:gsub("^" .. name, "")
        end

        if #splitted_cookie == 1 then
            if name == "Secure" then
                parsed_cookie.secure = true
            elseif name == "HttpOnly" then
                parsed_cookie.http_only = true
            else
                parsed_cookie.name = name
                parsed_cookie.value = "true"
            end
        else
            if name == "Expires" then
                -- TODO - parse value as time
                -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date
                parsed_cookie.expires = value
            elseif name == "Max-Age" then
                parsed_cookie.max_age = tonumber(value)
            elseif name == "Domain" then
                parsed_cookie.domain = value
            elseif name == "Path" then
                parsed_cookie.path = value
            elseif name == "SameSite" and value == "Strict" then
                parsed_cookie.same_site_strict = true
            elseif name == "SameSite" and value == "Lax" then
                parsed_cookie.same_site_lax = true
            elseif name == "SameSite" and value == "None" then
                parsed_cookie.same_site_none = true
            else
                parsed_cookie.name = name
                parsed_cookie.value = value
            end
        end
    end

    if parsed_cookie.name == nil or parsed_cookie.value == nil then
        error("cannot parse cookie string name or value")
    end

    return parsed_cookie
end

--- A good default CookieStore implementation.
-- This is the implementation used when simply calling cookie_store(true). This type is exposed to allow creating one and filling it with some existing cookies more easily, before creating a Client.
-- For more advanced scenarios, such as needing to serialize the store or manipulate it between requests, you may refer to the reqwest_cookie_store crate.
cookie.Jar = {}

function cookie.Jar:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function cookie.Jar:add_cookie_str(cookie_str, url)
    assert(type(cookie_str) == "string", "cookie_str should be string")
    assert(type(url) == "string", "url should be string")

    local domain = socket_url.parse(url).host
    local parsed_cookie = cookie.parse(cookie_str)

    if parsed_cookie.domain then
        domain = parsed_cookie.domain
    end

    if self[domain] == nil then
        self[domain] = {}
    end

    table.insert(self[domain], parsed_cookie)
end

--- Store a set of Set-Cookie header values received from url
function cookie.Jar:set_cookies(headers, url)
    assert(type(headers) == "table", "headers should be table")
    assert(type(url) == "string", "url should be string")

    local cookie_str = headers["set-cookie"] or headers["Set-Cookie"]

    if cookie_str then
        self:add_cookie_str(cookie_str, url)
    end
end

--- Get any Cookie values in the store for url
function cookie.Jar:cookies(url)
    assert(type(url) == "string", "url should be string")
    local parsed_url = socket_url.parse(url)
    local domain = parsed_url.host
    local cookie_str = ""

    if self[domain] then
        for _, single_cookie in pairs(self[domain]) do
            if single_cookie.path == nil or single_cookie.path == "/" or single_cookie.path == parsed_url.path then
                if cookie_str == "" then
                    cookie_str = single_cookie.name .. "=" .. single_cookie.value
                else
                    cookie_str = cookie_str .. "; " .. single_cookie.name .. "=" .. single_cookie.value
                end
            end
        end
    end

    if cookie_str ~= "" then
        return cookie_str
    end
end

return cookie
