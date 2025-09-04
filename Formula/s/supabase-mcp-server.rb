class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.5.2.tgz"
  sha256 "e69d859fcf467d64f7b1927b06a5ddc5e81e2cb2561062e731572d06ee730a23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a01df5465b10480d2773e7d76f48d5704e0efcb5574fb9243ec1641609f6312"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-supabase" => "supabase-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase-mcp-server --version")

    ENV["SUPABASE_ACCESS_TOKEN"] = "test-token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Lists all Supabase projects for the user", pipe_output(bin/"supabase-mcp-server", json, 0)
  end
end
