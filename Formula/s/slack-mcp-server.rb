class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.1.28.tar.gz"
  sha256 "71d6a6de907d4bc2a9927d434dc1a686ec4ccfda2730fb3d3fac58b0126e5114"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a87170e1df64c8b57a289c9fa2d69163f812ae37ce0927c409c9c3969ec81b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a87170e1df64c8b57a289c9fa2d69163f812ae37ce0927c409c9c3969ec81b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a87170e1df64c8b57a289c9fa2d69163f812ae37ce0927c409c9c3969ec81b"
    sha256 cellar: :any_skip_relocation, sonoma:        "779bcdae54a60e8b029f5d2d08c5bbf79677064f73e3257a28e5a56669143f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd9f99985af803e963d4e0bf1d066df16827429eb8918513ec57b7d9e3e51998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e661e69d4fd69416c4854cf539f12006e1074d204e4b917688c399c112a5ce3e"
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
