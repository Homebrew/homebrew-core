class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "acc6ec39559bd8e4cb1d3eba29ce04a448f3c06501eebe086363848ee41ab7a5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31296b26237917cdce5afd4cbcf6fc544fcfbc391f93d8fa951d2f322b0311d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31296b26237917cdce5afd4cbcf6fc544fcfbc391f93d8fa951d2f322b0311d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31296b26237917cdce5afd4cbcf6fc544fcfbc391f93d8fa951d2f322b0311d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f11907dc109860f8ef2870e0ccdb42688365e6a43ffd40c4196804ad7811a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ea55608654c620009131361dfc7aa19a5f5469490a41bee9e1f0fae04c9d5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f731b632aac2feb29b7e37701f77ffee26b40dbf84c4ebc9431ed4944ebdfd78"
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
