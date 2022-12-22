-- REFRENCES: https://github.com/hyperium/http/blob/master/src/status.rs

--- HTTP status codes
--
-- Constants are provided for known status codes, including those in the IANA
-- <a href="https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml">HTTP Status Code Registry</a>
-- Values above 599 are unclassified but allowed forContinue legacy compatibility, though their use is discouraged.
-- Applications may interpret such values as protocol errors.
-- @module requests.status

status = {
    --- 100 Continue
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.2.1">RFC7231, Section 6.2.1</a>]
    CONTINUE = 100,
    --- 101 Switching Protocols
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.2.2">RFC7231, Section 6.2.2</a>]
    SWITCHING_PROTOCOLS = 101,
    --- 102 Processing
    -- [<a href="https://tools.ietf.org/html/rfc2518">RFC2518</a>]
    PROCESSING = 102,

    --- 200 OK
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.3.1">RFC7231, Section 6.3.1</a>]
    OK = 200,
    --- 201 Created
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.3.2">RFC7231, Section 6.3.2</a>]
    CREATED = 201,
    --- 202 Accepted
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.3.3">RFC7231, Section 6.3.3</a>]
    ACCEPTED = 202,
    --- 203 Non-Authoritative Information
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.3.4">RFC7231, Section 6.3.4</a>]
    NON_AUTHORITATIVE_INFORMATION = 203,
    --- 204 No Content
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.3.5">RFC7231, Section 6.3.5</a>]
    NO_CONTENT = 204,
    --- 205 Reset Content
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.3.6">RFC7231, Section 6.3.6</a>]
    RESET_CONTENT = 205,
    --- 206 Partial Content
    -- [<a href="https://tools.ietf.org/html/rfc7233#section-4.1">RFC7233, Section 4.1</a>]
    PARTIAL_CONTENT = 206,
    --- 207 Multi-Status
    -- [<a href="https://tools.ietf.org/html/rfc4918">RFC4918</a>]
    MULTI_STATUS = 207,
    --- 208 Already Reported
    -- [<a href="https://tools.ietf.org/html/rfc5842">RFC5842</a>]
    ALREADY_REPORTED = 208,

    --- 226 IM Used
    -- [<a href="https://tools.ietf.org/html/rfc3229">RFC3229</a>]
    IM_USED = 226,

    --- 300 Multiple Choices
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.4.1">RFC7231, Section 6.4.1</a>]
    MULTIPLE_CHOICES = 300,
    --- 301 Moved Permanently
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.4.2">RFC7231, Section 6.4.2</a>]
    MOVED_PERMANENTLY = 301,
    --- 302 Found
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.4.3">RFC7231, Section 6.4.3</a>]
    FOUND = 302,
    --- 303 See Other
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.4.4">RFC7231, Section 6.4.4</a>]
    SEE_OTHER = 303,
    --- 304 Not Modified
    -- [<a href="tps://tools.ietf.org/html/rfc7232#section-4.1)]">RFC7232, Section 4.1](</a>t
    NOT_MODIFIED = 304,
    --- 305 Use Proxy
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.4.5">RFC7231, Section 6.4.5</a>]
    USE_PROXY = 305,
    --- 307 Temporary Redirect
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.4.7">RFC7231, Section 6.4.7</a>]
    TEMPORARY_REDIRECT = 307,
    --- 308 Permanent Redirect
    -- [<a href="https://tools.ietf.org/html/rfc7238">RFC7238</a>]
    PERMANENT_REDIRECT = 308,

    --- 400 Bad Request
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.1">RFC7231, Section 6.5.1</a>]
    BAD_REQUEST = 400,
    --- 401 Unauthorized
    -- [<a href="tps://tools.ietf.org/html/rfc7235#section-3.1)]">RFC7235, Section 3.1](</a>t
    UNAUTHORIZED = 401,
    --- 402 Payment Required
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.2">RFC7231, Section 6.5.2</a>]
    PAYMENT_REQUIRED = 402,
    --- 403 Forbidden
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.3">RFC7231, Section 6.5.3</a>]
    FORBIDDEN = 403,
    --- 404 Not Found
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.4">RFC7231, Section 6.5.4</a>]
    NOT_FOUND = 404,
    --- 405 Method Not Allowed
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.5">RFC7231, Section 6.5.5</a>]
    METHOD_NOT_ALLOWED = 405,
    --- 406 Not Acceptable
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.6">RFC7231, Section 6.5.6</a>]
    NOT_ACCEPTABLE = 406,
    --- 407 Proxy Authentication Required
    -- [<a href="https://tools.ietf.org/html/rfc7235#section-3.2">RFC7235, Section 3.2</a>
    PROXY_AUTHENTICATION_REQUIRED = 407,
    --- 408 Request Timeout
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.7">RFC7231, Section 6.5.7</a>]
    REQUEST_TIMEOUT = 408,
    --- 409 Conflict
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.8">RFC7231, Section 6.5.8</a>]
    CONFLICT = 409,
    --- 410 Gone
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.9">RFC7231, Section 6.5.9</a>]
    GONE = 410,
    --- 411 Length Required
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.10">RFC7231, Section 6.5.10</a>]
    LENGTH_REQUIRED = 411,
    --- 412 Precondition Failed
    -- [<a href="https://tools.ietf.org/html/rfc7232#section-4.2">RFC7232, Section 4.2</a>
    PRECONDITION_FAILED = 412,
    --- 413 Payload Too Large
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.11">RFC7231, Section 6.5.11</a>]
    PAYLOAD_TOO_LARGE = 413,
    --- 414 URI Too Long
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.12">RFC7231, Section 6.5.12</a>]
    URI_TOO_LONG = 414,
    --- 415 Unsupported Media Type
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.13">RFC7231, Section 6.5.13</a>]
    UNSUPPORTED_MEDIA_TYPE = 415,
    --- 416 Range Not Satisfiable
    -- [<a href="https://tools.ietf.org/html/rfc7233#section-4.4">RFC7233, Section 4.4</a>]
    RANGE_NOT_SATISFIABLE = 416,
    --- 417 Expectation Failed
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.14">RFC7231, Section 6.5.14</a>]
    EXPECTATION_FAILED = 417,
    --- 418 I'm a teapot
    -- [curiously not registered by IANA but <a href="https://tools.ietf.org/html/rfc2324">RFC2324</a>]
    IM_A_TEAPOT = 418,

    --- 421 Misdirected Request
    -- [<a href="http://tools.ietf.org/html/rfc7540#section-9.1.2">RFC7540, Section 9.1.2</a>]
    MISDIRECTED_REQUEST = 421,
    --- 422 Unprocessable Entity
    -- [<a href="https://tools.ietf.org/html/rfc4918">RFC4918</a>]
    UNPROCESSABLE_ENTITY = 422,
    --- 423 Locked
    -- [<a href="https://tools.ietf.org/html/rfc4918">RFC4918</a>]
    LOCKED = 423,
    --- 424 Failed Dependency
    -- [<a href="https://tools.ietf.org/html/rfc4918">RFC4918</a>]
    FAILED_DEPENDENCY = 424,

    --- 426 Upgrade Required
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.5.15">RFC7231, Section 6.5.15</a>]
    UPGRADE_REQUIRED = 426,

    --- 428 Precondition Required
    -- [<a href="https://tools.ietf.org/html/rfc6585">RFC6585</a>]
    PRECONDITION_REQUIRED = 428,
    --- 429 Too Many Requests
    -- [<a href="https://tools.ietf.org/html/rfc6585">RFC6585</a>]
    TOO_MANY_REQUESTS = 429,

    --- 431 Request Header Fields Too Large
    -- [<a href="https://tools.ietf.org/html/rfc6585">RFC6585</a>]
    REQUEST_HEADER_FIELDS_TOO_LARGE = 431,

    --- 451 Unavailable For Legal Reasons
    -- [<a href="http://tools.ietf.org/html/rfc7725">RFC7725</a>]
    UNAVAILABLE_FOR_LEGAL_REASONS = 451,

    --- 500 Internal Server Error
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.6.1">RFC7231, Section 6.6.1</a>]
    INTERNAL_SERVER_ERROR = 500,
    --- 501 Not Implemented
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.6.2">RFC7231, Section 6.6.2</a>]
    NOT_IMPLEMENTED = 501,
    --- 502 Bad Gateway
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.6.3">RFC7231, Section 6.6.3</a>]
    BAD_GATEWAY = 502,
    --- 503 Service Unavailable
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.6.4">RFC7231, Section 6.6.4</a>]
    SERVICE_UNAVAILABLE = 503,
    --- 504 Gateway Timeout
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.6.5">RFC7231, Section 6.6.5</a>]
    GATEWAY_TIMEOUT = 504,
    --- 505 HTTP Version Not Supported
    -- [<a href="https://tools.ietf.org/html/rfc7231#section-6.6.6">RFC7231, Section 6.6.6</a>]
    HTTP_VERSION_NOT_SUPPORTED = 505,
    --- 506 Variant Also Negotiates
    -- [<a href="https://tools.ietf.org/html/rfc2295">RFC2295</a>]
    VARIANT_ALSO_NEGOTIATES = 506,
    --- 507 Insufficient Storage
    -- [<a href="https://tools.ietf.org/html/rfc4918">RFC4918</a>]
    INSUFFICIENT_STORAGE = 507,
    --- 508 Loop Detected
    -- [<a href="https://tools.ietf.org/html/rfc5842">RFC5842</a>]
    LOOP_DETECTED = 508,

    --- 510 Not Extended
    -- [<a href="https://tools.ietf.org/html/rfc2774">RFC2774</a>]
    NOT_EXTENDED = 510,
    --- 511 Network Authentication Required
    -- [<a href="https://tools.ietf.org/html/rfc6585">RFC6585</a>]
    NETWORK_AUTHENTICATION_REQUIRED = 511,
}

--- Class to perform basic status code checks.
-- @type StatusCode
status.StatusCode = {}

--- Create a new instance of @{StatusCode}.
-- @param[number] code status code
-- @return @{StatusCode}
function status.StatusCode:new(code)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.code = (type(code) == "string") and tonumber(code) or code
    return o
end

--- Check if status is within 100-199.
function status.StatusCode:is_informational()
    return 200 > self.code and self.code >= 100
end

--- Check if status is within 200-299.
function status.StatusCode:is_success()
    return 300 > self.code and self.code >= 200
end

--- Check if status is within 300-399.
function status.StatusCode:is_redirection()
    return 400 > self.code and self.code >= 300
end

--- Check if status is within 400-499.
function status.StatusCode:is_client_error()
    return 500 > self.code and self.code >= 400
end

--- Check if status is within 500-599.
function status.StatusCode:is_server_error()
    return 600 > self.code and self.code >= 500
end

return status
