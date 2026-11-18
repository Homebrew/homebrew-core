class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.18.0.tgz"
  sha256 "7bc9ad654ef267d7f7738dda507fdf4245d41d37eb0f9da4814b26aad95d0c42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73d166b74460564ee7c148e71b2ba3510fc0ced8bba57b208e8d4f54c719e5fd"
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
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    # Read the replies before closing stdin: 0.14.0 exits on EOF before answering `tools/list`
    output = IO.popen(bin/"supabase-mcp-server", "r+") do |io|
      io.write json
      io.readline
      io.readline
    end
    assert_match "Lists all Supabase projects for the user", output
  end
end
