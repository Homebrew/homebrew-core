class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.30.15.tgz"
  sha256 "7cd9f0a3437b5102d01d8d629fd1666487414c1256487fe60245a86b66e831b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c4efba20a8ae240b9387c3f9f0c25cdf0fdd3a7702b9f46aeadab882671070d"
  end

  depends_on "node"

  def install
    # @salesforce/mcp → mcp-provider-dx-core → @salesforce/agents
    #   ⮑ nock  (required: ^13.5.6)
    # The default `std_npm_args` ignores the nested lockfile and resolves `nock@14`,
    # which is incompatible with the current version of @salesforce/agents.
    # `npm ci` keeps the locked `nock@13` and never installs `@mswjs/interceptors`.
    # TODO: check formula works with nock@14 and then recover npm install.
    system "npm", "ci", "--omit=dev", "--ignore-scripts"
    libexec.install Dir["*"]
    (bin/"sf-mcp-server").write_env_script libexec/"bin/run.js", PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sf-mcp-server --version 2>&1")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/sf-mcp-server --orgs DEFAULT_TARGET_ORG --toolsets all 2>&1", json, 0)
    assert_match "The username or alias for the Salesforce org to run this tool against", output
  end
end
