class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.16.0.tgz"
  sha256 "1187dc4612a88c63d4191028c6a725897a05ecb3a73fbfa5b02f7f2554517f65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d33dbb94edd3ccc378a11b4139cdb488aec4c3ec7092257972a1aab161a58ec"
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
