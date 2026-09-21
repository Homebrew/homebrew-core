class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6804f0a07c5c3bdf6d24d8c65740c104d543cbabb027f9378abb8ce2aab97af5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8989b191106074b74f55b6a1d96e1f0b14ad85e100eb5d8e802cfa41e2063fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "468180403b407351dc1494910f1b3939e88b206c8a66c85e26edaab21acac614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "468180403b407351dc1494910f1b3939e88b206c8a66c85e26edaab21acac614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "468180403b407351dc1494910f1b3939e88b206c8a66c85e26edaab21acac614"
    sha256 cellar: :any_skip_relocation, sonoma:            "740bb8d045cfc08df91c74c3e1feec74b0dd0c0c93730434181f0fa2756bc4ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7fc6d0f705fa4624bb0d61ffc3a9a3cd34a22b494b41d292750e23e889f0bf3d"
    sha256 cellar: :any,                 x86_64_linux:      "0440457e1924118b19b14c364db704ab2c8935b7d5eb32ba084d3446f0710bb1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
