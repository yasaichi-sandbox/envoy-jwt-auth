local function isAuthorized(payload, claim, value)
  return type(payload[claim]) == "string" and
      (
        string.find(payload[claim], "^" .. value .. "%s") or
        string.find(payload[claim], "%s" .. value .. "%s") or
        string.find(payload[claim], "%s" .. value .. "$") or
        string.find(payload[claim], "^" .. value .. "$")
      )
end

function envoy_on_request(request_handle)
  local meta = request_handle:streamInfo():dynamicMetadata():get("envoy.filters.http.jwt_authn")

  if (meta == nil or meta["jwt_payload"] == nil) then
    request_handle:logErr("No JWT payload found. Set `payload_in_metadata` option.")
    -- NOTE: As http filters continue to run even if error is thrown, we need to respond with an error.
    request_handle:respond({ [":status"] = "500" }, "Something went wrong.")
    return
  end

  if not isAuthorized(meta["jwt_payload"], "scope", "user%.profile") then
    request_handle:respond({ [":status"] = "403" }, "Unauthorized")
  end
end
