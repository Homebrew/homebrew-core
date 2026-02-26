class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.26.11.tgz"
  sha256 "11202da9dada8c0a567e93cc3e5036db30343f2b75ae58d6ca1e740a03e59d18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9003ac7caa15c5057202f8058b2789d5114e9cc8f3a9a795b7a9c71899efb56"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Upstream ships with eslint, but `mcp-provider-lwc-experts` uses deprecated eslintrc, causing an error
    node_module = libexec/"lib/node_modules/@salesforce/mcp/node_modules"
    inreplace node_module/"@salesforce/mcp-provider-lwc-experts/index.bundle.js",
              /reportUnusedDisableDirectives:\s?['"]\w+?['"],?/, ""
    inreplace node_module/"@salesforce/mcp-provider-lwc-experts/index.bundle.js",
              /useEslintrc:!1,/, ""
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sf-mcp-server --version 2>&1")

    input = testpath/"in"
    input.write <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = testpath/"out"

    # the mcp server does not respond to SIGINT so pipe_output would run indefinetly until test timeout
    pid = spawn bin/"sf-mcp-server", "--orgs", "DEFAULT_TARGET_ORG", "--toolsets", "all",
          [:out, :err] => output.to_s, [:in] => input.to_s

    sleep 10

    assert_match "The username or alias for the Salesforce org to run this tool against", output.read
  ensure
    Process.kill("KILL", pid)
    Process.wait
  end
end
