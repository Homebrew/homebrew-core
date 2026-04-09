class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2c47012663357a46ab5702999b25f17efe8d0cc2214231944202aa87bceb8139"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc2bf56d6c30b6d8a3e9a67ade87e40e0e7ec0740194ea2fa68352d6d8ca5bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc2bf56d6c30b6d8a3e9a67ade87e40e0e7ec0740194ea2fa68352d6d8ca5bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc2bf56d6c30b6d8a3e9a67ade87e40e0e7ec0740194ea2fa68352d6d8ca5bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f6cbe9b50fa38d5787ac1e4d26b73bc2bc0917f7bd8873713c0df0a5bd8221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5585c11145f6a5519879d9e03b112dfa1f9bd7e2190e3c730c842e81825aa719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee81e27a0cd66787cde02691579b5b6b6b9383c568745af755ff12c0a5ac35b3"
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
