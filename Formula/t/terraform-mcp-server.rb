class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2c47012663357a46ab5702999b25f17efe8d0cc2214231944202aa87bceb8139"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5afc8dc0c0522f6b6b2ae35380e4bfd2a2608164c1fcede51bec03bc1ede3397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5afc8dc0c0522f6b6b2ae35380e4bfd2a2608164c1fcede51bec03bc1ede3397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5afc8dc0c0522f6b6b2ae35380e4bfd2a2608164c1fcede51bec03bc1ede3397"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad434ccaeda98d318260f96603344922f01bd2e49836ca2e5c2ca449dd3bf731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98929ed661a966663c3d49f8afe49dda31bafbe5c643e1ad29beec2bb7576a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8aecb8b94fe339bf0d58be472a436082a28daa0e42c70eb351a78a8d2f4ed2"
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
    generate_completions_from_executable(bin/"terraform-mcp-server", shell_parameter_format: :cobra)
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
