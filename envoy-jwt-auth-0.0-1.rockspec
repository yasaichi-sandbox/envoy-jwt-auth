package = "envoy-jwt-auth"
version = "0.0-1"
source = {
    url = "git://github.com/yasaichi-sandbox/envoy-jwt-auth.git"
}

dependencies = {
   "lua = 5.1",
   "moonscript >= 0.5",
   "busted >= 2.2",
   "luacov >= 0.16"
}

build = {
   type = "builtin",
   modules = {
      mymodule = "envoy/jwt_authorization_filter.lua"
   }
}
