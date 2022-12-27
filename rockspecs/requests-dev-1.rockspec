package = "requests"
version = "dev-1"
source = {
   url = "git://github.com/lua-batteries/requests"
}
description = {
   summary = "HTTP requests made easy! Support for HTTPS, Basic Auth, Digest Auth. HTTP response parsing has never been easier!",
   detailed = [[Similar to Requests for python.
      The goal of lua-requests is to make HTTP simple and easy to use.
      Currently HTTPS, Basic Authentication, and Digest Authentication are supported.
      Checkout the wiki on the github page for more details. Written in pure lua!
   ]],
   homepage = "https://github.com/lua-batteries/requests",
   license = "MIT"
}
dependencies = {
  "lua >= 5.1",
  "luasec >= 1.2.0"
  "luasocket",
  -- "md5",
  -- "lua-cjson",
  -- "xml",
}
build = {
   type = "builtin",
   modules = {
      requests = "src/requests.lua"
   }
}
