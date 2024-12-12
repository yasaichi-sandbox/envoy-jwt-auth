require 'busted.runner' ()
require 'envoy/jwt_authorization_filter'

describe("envoy_on_request", function()
  local get

  local request_handle = {
    logErr = function() end,
    respond = function(headers, body) end,
    streamInfo = function()
      return {
        dynamicMetadata = function()
          return { get = get }
        end
      }
    end
  }

  before_each(function()
    stub(request_handle, "respond")
  end)

  after_each(function()
    request_handle.respond:revert()
  end)

  context("when the metadata is not set", function()
    before_each(function()
      get = function() return nil end
    end)

    it("should respond with status 500", function()
      assert.has_no.errors(function() envoy_on_request(request_handle) end)
      assert.stub(request_handle.respond).was.called_with(
        match.is_ref(request_handle),
        { [":status"] = "500" },
        "Something went wrong."
      )
    end)
  end)

  context("when jwt payload is not included in the metadata", function()
    before_each(function()
      get = function() return {} end
    end)

    it("should respond with status 500", function()
      assert.has_no.errors(function() envoy_on_request(request_handle) end)
      assert.stub(request_handle.respond).was.called_with(
        match.is_ref(request_handle),
        { [":status"] = "500" },
        "Something went wrong."
      )
    end)
  end)

  context("when jwt payload is included in the metadata", function()
    local scope

    before_each(function()
      get = function() return { jwt_payload = { scope = scope } } end
    end)

    context("when the scope claim does not include `user.profile`", function()
      before_each(function()
        scope = "user.profiles superuser.profile"
      end)

      it("should respond with status 403", function()
        assert.has_no.errors(function() envoy_on_request(request_handle) end)
        assert.stub(request_handle.respond).was.called_with(
          match.is_ref(request_handle),
          { [":status"] = "403" },
          "Unauthorized"
        )
      end)
    end)

    context("when the scope claim includes `user.profile`", function()
      before_each(function()
        scope = "user.details user.profile"
      end)

      it("should succeed without any error", function()
        assert.has_no.errors(function() envoy_on_request(request_handle) end)
        assert.stub(request_handle.respond).was_not.called()
      end)
    end)
  end)
end)
