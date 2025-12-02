class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.1.26.tar.gz"
  sha256 "68ce43e9edbdb8df87aead39abfda1d068e21559b2bbd341531fb7715e1e7425"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2439f83defc3ac28c6c9ba104bfd44a4fd6b48dcdedd83e17bc750a5e582ebdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2439f83defc3ac28c6c9ba104bfd44a4fd6b48dcdedd83e17bc750a5e582ebdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2439f83defc3ac28c6c9ba104bfd44a4fd6b48dcdedd83e17bc750a5e582ebdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c108eb0fa0be8507791a776424b3ed7721fb895ad1c5495594675e20951c7061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80eafafc6331e4a0cbfb3be27957b14f091073e7621acbd40b50b4684ff2ad2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99e6668d73c9caa0089f0a999e53a7eac869b13c0ee8054ca0e614428746c0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slack-mcp-server"
  end

  test do
    # User OAuth token
    ENV["SLACK_MCP_XOXP_TOKEN"] = "xoxp-test-token"
    assert_match "Failed to create MCP Slack client", shell_output("#{bin}/slack-mcp-server 2>&1", 1)
  end
end
