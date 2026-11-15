class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8c744e2ad553ee37db41b66a0f2dbb6532939c00e17b5f00bd10f5809f6f3990"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43bde70b5a0176e3c97cde0710b392b82cebc7f34028d7e957865e090bd569a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43bde70b5a0176e3c97cde0710b392b82cebc7f34028d7e957865e090bd569a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43bde70b5a0176e3c97cde0710b392b82cebc7f34028d7e957865e090bd569a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e2f08506e098a32a03e8a736f504a61b80f6721e7ad4ede778278c707187337"
    sha256 cellar: :any,                 x86_64_linux:      "d4c5583d9031f436ecfcc6f68918feeb82bb4941f7c69a1a3cd374d2a3742eb8"
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
