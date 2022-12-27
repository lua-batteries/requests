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
local date = require("requests.date")

cookie = {}

--- A single HTTP cookie.
-- @return {
--     name: string, -- required
--     value: string, -- required
--     domain: string,
--     expires: number,
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

    local pcookie = {}

    for cookie_value in cookie:gmatch("(.-;%s)") do
        cookie_value = cookie_value:sub(0, cookie_value:len() - 2) -- trim "; "

        if cookie_value:find("^Secure") ~= nil then
            pcookie.secure = true
        elseif cookie_value:find("^HttpOnly") ~= nil then
            pcookie.http_only = true
        else
            if cookie_value:find("^Expires") ~= nil then
                pcookie.expires = date.parse(cookie_value:sub(9, cookie_value:len()))
            elseif cookie_value:find("^Max-Age") ~= nil then
                pcookie.max_age = tonumber(cookie_value:sub(9, cookie_value:len()))
            elseif cookie_value:find("^Domain") ~= nil then
                pcookie.domain = cookie_value:sub(8, cookie_value:len())
            elseif cookie_value:find("^Path") ~= nil then
                pcookie.path = cookie_value:sub(6, cookie_value:len())
            elseif cookie_value:find("^SameSite=Strict") ~= nil then
                pcookie.same_site_strict = true
            elseif cookie_value:find("^SameSite=Lax") ~= nil then
                pcookie.same_site_lax = true
            elseif cookie_value:find("^SameSite=None") ~= nil then
                pcookie.same_site_none = true
            elseif cookie_value:find("^__Host-") ~= nil then
                -- DO NOTHING
            elseif cookie_value:find("^__Secure-") ~= nil then
                -- DO NOTHING
            else
                if pcookie.name ~= nil then
                    error("cannot parse multiple cookies at one time")
                end

                pcookie.name = cookie_value:match("^[%w_]+=")

                if pcookie.name == nil then
                    error("cannot parse cookie name")
                end

                pcookie.value = cookie_value:sub(pcookie.name:len() + 1, cookie_value:len())

                -- trim ""
                if pcookie.value:find("^\"") ~= nil then
                    pcookie.value = pcookie.value:sub(2, pcookie.value:len() - 1)
                end

                pcookie.name = pcookie.name:sub(0, pcookie.name:len() - 1)
            end
        end
    end

    if pcookie.name == nil or pcookie.value == nil then
        error("cannot parse cookie string name or value")
    end

    return pcookie
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

    -- print(parsed_cookie.name, parsed_cookie.value)
    table.insert(self[domain], parsed_cookie)
end

function cookie.Jar:_add_multiple_cookies(multiple_cookie_str, url)
    local next_cookie = multiple_cookie_str:find(",%s[%w_]+=")

    if next_cookie then
        self:add_cookie_str(multiple_cookie_str:sub(0, next_cookie - 1), url)
        self:_add_multiple_cookies(multiple_cookie_str:sub(next_cookie + 2, multiple_cookie_str:len()), url)
    else
        self:add_cookie_str(multiple_cookie_str, url)
    end
end

--- Store a set of Set-Cookie header values received from url
function cookie.Jar:set_cookies(headers, url)
    assert(type(headers) == "table", "headers should be table")
    assert(type(url) == "string", "url should be string")

    local multiple_cookie_str = headers["set-cookie"] or headers["Set-Cookie"]

    if multiple_cookie_str then
        self:_add_multiple_cookies(multiple_cookie_str, url)
    end
end

--- Get any Cookie values in the store for url
function cookie.Jar:cookies(url)
    assert(type(url) == "string", "url should be string")
    local parsed_url = socket_url.parse(url)
    local domain = parsed_url.host
    local cookie_str = ""
    local cookies = self[domain]

    if not cookies then
        local _, domain_end = domain:find("^[%w_]+%.")

        if domain then
            cookies = self[domain:sub(domain_end, domain:len())] or self[domain:sub(domain_end + 1, domain:len())]
        end
    end

    if cookies then
        for _, single_cookie in pairs(cookies) do
            local is_path = single_cookie.path == nil or single_cookie.path == "/" or
                single_cookie.path == parsed_url.path
            local is_scheme = true

            if single_cookie.secure then
                is_scheme = parsed_url.scheme == "https"
            elseif single_cookie.http_only then
                is_scheme = parsed_url.scheme == "http"
            end

            local is_expired = false

            if single_cookie.expires then
                is_expired = date.is_expired(single_cookie.expires)
            end

            if is_path and is_scheme and not is_expired then
                if cookie_str == "" then
                    cookie_str = single_cookie.name .. "=\"" .. single_cookie.value .. "\""
                else
                    cookie_str = cookie_str .. "; " .. single_cookie.name .. "=\"" .. single_cookie.value .. "\""
                end
            end
        end
    end

    if cookie_str ~= "" then
        return cookie_str
    end
end

return cookie
