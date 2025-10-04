class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.23.3.tgz"
  sha256 "fd6f6a8ae821e29b143e4c852902ae5553ae471548a375187b2fe9d48c538c85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48235fd1a4de4610022e56b46ca290b54eaccdd78a935e4c99f8f69c0ef42b9a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
