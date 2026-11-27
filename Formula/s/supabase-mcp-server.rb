class SupabaseMcpServer < Formula
  desc "MCP Server for Supabase"
  homepage "https://supabase.com/docs/guides/getting-started/mcp"
  url "https://registry.npmjs.org/@supabase/mcp-server-supabase/-/mcp-server-supabase-0.21.0.tgz"
  sha256 "68fceccc5fda639df7b1ad79354d0978f063c3115dbf21b7f064245b6ad88785"
  license "MIT"

  bottle do
    manifest_sha256 "cdaae6ccc10e330850d990d79424d0e3fc6f5fde9f4cb5d4f3d41bce38b11ac3"
    sha256 cellar: :any_skip_relocation, all: "7e030fa8b9bc53419b1ef7ce1093ff691781e97a52f29d7db5b9c2c5bbe83e72"
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
