class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "1e60b00d0079d3603401dc92aa92151539e5cf2b80c8bf0834484828b5aa398c"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ce7795ed0e0b91736a0caaed1d9ede411afe46fefa40a69dd38b313f299fcda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ce7795ed0e0b91736a0caaed1d9ede411afe46fefa40a69dd38b313f299fcda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce7795ed0e0b91736a0caaed1d9ede411afe46fefa40a69dd38b313f299fcda"
    sha256 cellar: :any_skip_relocation, sonoma:        "3568abb4db3b4699c16aca5e73d1f758a9fda13ffcdf0ee29f1a2f932124671e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a5aa42932e46af21036c2659cb5ff535e9bde98856c56680bd96084a9877f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3ae09b5bdb8fc06671bc6f64cbabf265f36915c3fbd6dc269e9a1d15cde098"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slack-mcp-server"
  end

  test do
    # User OAuth token
    ENV["SLACK_MCP_XOXP_TOKEN"] = "xoxp-test-token"
    output = shell_output("#{bin}/slack-mcp-server 2>&1", 1)
    assert_match(/Failed to create MCP Slack client|Authentication failed - check your Slack tokens/, output)
  end
end
