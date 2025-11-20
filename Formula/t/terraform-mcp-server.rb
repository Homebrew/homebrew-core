class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "885453e9e5125d6b995e362dd5fe06edbdd5ef1188f35a43c37bccf844c61ba9"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bea6e10d906c112aced5820d8786d38f4caaf97b79b50a30bb68cab0d9b358c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bea6e10d906c112aced5820d8786d38f4caaf97b79b50a30bb68cab0d9b358c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bea6e10d906c112aced5820d8786d38f4caaf97b79b50a30bb68cab0d9b358c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab6e6bdf3f7101e6eda09dd3927b8b112de455658cc6090606d1738d7e50c799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c046b54f8b6aa375826a78fba51106c2026482bff503b143e29f7da709aa27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec290ff35e4f5c73be34c12d000cd71be0a841b853119ac64291b27921f84d5"
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
