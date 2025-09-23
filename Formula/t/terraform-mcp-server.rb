class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "6148a9099899fab41a818bd905b8c6f495ceb5105d3611d3192b2e677924778e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09fcb010bd9a7ad7ff6cb419e91450bee614defc1fa7ed618687174950f90038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b50aae2663e7e4a1c5d5a9e4345a72c6397071bedba5bf04434878c1476c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b50aae2663e7e4a1c5d5a9e4345a72c6397071bedba5bf04434878c1476c3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85b50aae2663e7e4a1c5d5a9e4345a72c6397071bedba5bf04434878c1476c3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a3958a4c37f03e795d30a76627439ec3687f7b658a5a429180f668a25bb8e5"
    sha256 cellar: :any_skip_relocation, ventura:       "c1a3958a4c37f03e795d30a76627439ec3687f7b658a5a429180f668a25bb8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993966ce6b21dc2346dab463134e347c792eab4a61dc00919e8c8e71ced03d9a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/terraform-mcp-server/version.GitCommit=#{tap.user}
      -X github.com/hashicorp/terraform-mcp-server/version.BuildDate=#{time.iso8601}
      -X github.com/hashicorp/terraform-mcp-server/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/terraform-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"terraform-mcp-server", json, 0)
    assert_match "Fetches the latest version of a Terraform module from the public registry", output
  end
end
