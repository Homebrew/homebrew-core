class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.1.25.tar.gz"
  sha256 "c1dff427ea3a9469c59d54ddd07a5b6281e55ad24936f9feac72c7c23a911854"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ddf1f54c2c3caa2f22da65139ce3af4932804302c6ba59e66d84cdca476290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ddf1f54c2c3caa2f22da65139ce3af4932804302c6ba59e66d84cdca476290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ddf1f54c2c3caa2f22da65139ce3af4932804302c6ba59e66d84cdca476290"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5dade36ebeb9d67051c5e827af1cc07fc4d441ba1af612cae610c09a5f43d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f14c368241deb416b2a9297c8f073c798eaea1f4277f64b720ab1e0a7bf68fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5d405c8d6b3f6b8a365806468025b47615995352a62d26ee8a87df76bef2d9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slack-mcp-server"
  end

  test do
    # User OAuth token
    ENV["SLACK_MCP_XOXP_TOKEN"] = "xoxp-test-token"
    assert_match "Failed to create MCP Slack client", shell_output("#{bin}/slack-mcp-server 2>&1", 1)
  end
end
