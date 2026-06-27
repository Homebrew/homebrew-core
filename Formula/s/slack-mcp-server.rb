class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "815b7852124b33823bd33f9d505149b876cc3a220259e379687304a19957f916"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15e366083bce32ec803d35696e78194e86ae63dba5feb887c7f401bce88b50b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e366083bce32ec803d35696e78194e86ae63dba5feb887c7f401bce88b50b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e366083bce32ec803d35696e78194e86ae63dba5feb887c7f401bce88b50b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "793d25b798febe652e174a21738a0ec3e0ee9efe289b0c6eaac415d3ba92ecd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f2faa5acbdb0475681164cc2e986b268ee66796c78a7f1c4fc472bcfc6c3257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4420b5c9bf2461ad14b153eab81b039f407d1ec97a98db8916aaf3c81233c52"
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
