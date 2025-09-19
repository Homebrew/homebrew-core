class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.5.5.tgz"
  sha256 "1b2da46d02476b081642e3e476a91b147912e702ad53cac7c6c0a510dcc1ab11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "746a95ef76567d162fbf7cb562dec54815ef3c3674facfd2cf855755b65b69e5"
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
