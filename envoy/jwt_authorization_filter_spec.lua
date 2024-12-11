require 'busted.runner' ()

describe("envoy_on_request", function()
  context("when jwt payload is not set", function()
    it("should respond with status 500", function()
    end)
  end)

  context("when jwt payload is set", function()
    context("when the scope claim does not include `user.profile`", function()
      it("should respond with status 403", function()
      end)
    end)

    context("when the scope claim includes `user.profile`", function()
      it("should do nothing", function()
      end)
    end)
  end)
end)
