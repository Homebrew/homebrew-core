class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "b5082ff04d1f174b099bc099029c43c25ac2f6156bba0e930ecaf4f6d8549eaf"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2cfe60f4d28898a1f82ce51b7689d663f28882e5f02aed961f2cb02a01cc4e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2cfe60f4d28898a1f82ce51b7689d663f28882e5f02aed961f2cb02a01cc4e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2cfe60f4d28898a1f82ce51b7689d663f28882e5f02aed961f2cb02a01cc4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c84b428b6d35768cdf0981418fb9534c16c00dd8240f0ebe7bd260b62783880e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7592718a89964b10c289d1f6f1df5edd64fd2b8914a2a20ee5a6e910dc1edaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60215deaf0082dc956ef96ea323653d5d07ecd3670b172c3614f467a67a7165a"
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
