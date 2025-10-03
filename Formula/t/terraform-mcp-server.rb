class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "36b7c18c4ac9a1023a503e79fd8f208f67958e2c70462c79438b33e789a7a3e8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afb23353f074c5339cafa4248581f02a0a9a0913bfe9b3d4a024b6ae8748f396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb23353f074c5339cafa4248581f02a0a9a0913bfe9b3d4a024b6ae8748f396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb23353f074c5339cafa4248581f02a0a9a0913bfe9b3d4a024b6ae8748f396"
    sha256 cellar: :any_skip_relocation, sonoma:        "282a14f932230d8573e61716255a78cf7a6dd0833d2144d128d7a3118178d8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc08c6956bb6dfcdc2f4dcc8ee5ff40f0d08ccb599c811ec3f4cca42af2cd52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9149211137f3b12dd76e8b61d52d4065880c9c9b3bc8e510e05308d2dab8e1a4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
