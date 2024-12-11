local function isAuthorized(payload, claim, value)
  return type(payload[claim]) == "string" and string.find(payload[claim], value) ~= nil
end

function envoy_on_request(request_handle)
  local meta = request_handle:streamInfo():dynamicMetadata():get("envoy.filters.http.jwt_authn")

  if (meta["jwt_payload"] == nil) then
    request_handle:logErr("No JWT payload found. Set `payload_in_metadata` option.")
    request_handle:respond({ [":status"] = "500", }, "Something went wrong.")
    return
  end

  if not isAuthorized(meta["jwt_payload"], "scope", "user.profile") then
    request_handle:respond({ [":status"] = "403", }, "JWT validation failed.")
  end
end
