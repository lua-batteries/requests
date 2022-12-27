-- COPIED FROM: https://github.com/brunoos/luasec/blob/master/src/https.lua

----------------------------------------------------------------------------
-- LuaSec 1.2.0
-- Copyright (C) 2009-2022 PUC-Rio
--
-- Author: Pablo Musa
-- Author: Tomas Guisasola
---------------------------------------------------------------------------

local socket = require("socket")
local ssl    = require("ssl")

local try    = socket.try

--
-- Module
--
local _M = {
  _VERSION   = "1.2.0",
  _COPYRIGHT = "LuaSec 1.2.0 - Copyright (C) 2009-2022 PUC-Rio",
  PORT       = 443,
  TIMEOUT    = 60
}

-- TLS configuration
local cfg = {
  protocol = "any",
  options  = {"all", "no_sslv2", "no_sslv3", "no_tlsv1"},
  verify   = "none",
}

--------------------------------------------------------------------
-- Auxiliar Functions
--------------------------------------------------------------------

-- Forward calls to the real connection object.
local function reg(conn)
   local mt = getmetatable(conn.sock).__index
   for name, method in pairs(mt) do
      if type(method) == "function" then
         conn[name] = function (self, ...)
                         return method(self.sock, ...)
                      end
      end
   end
end

-- Return a function which performs the SSL/TLS connection.
local function tcp(params, tcp_socket) -- MODIFIED
   params = params or {}
   -- Default settings
   for k, v in pairs(cfg) do 
      params[k] = params[k] or v
   end
   -- Force client mode
   params.mode = "client"
   -- 'create' function for LuaSocket
   return function ()
      local conn = {}
      conn.sock = try(tcp_socket)
      local st = getmetatable(conn.sock).__index.settimeout
      function conn:settimeout(...)
         return st(self.sock, _M.TIMEOUT)
      end
      -- Replace TCP's connection function
      function conn:connect(host, port)
         try(self.sock:connect(host, port))
         self.sock = try(ssl.wrap(self.sock, params))
         self.sock:sni(host)
         self.sock:settimeout(_M.TIMEOUT)
         try(self.sock:dohandshake())
         reg(self)
         return 1
      end
      return conn
  end
end

--------------------------------------------------------------------------------
-- Export module
--

_M.tcp = tcp

return _M
