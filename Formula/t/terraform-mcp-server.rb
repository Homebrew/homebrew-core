class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9a091a639d5b8e3de05e2d09ecb59d896d6946a57a8d97fc859427841718dd34"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e59ac2058e262574c33cdb3322551813cd1f599dc9469fdac61aa5e056040a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e59ac2058e262574c33cdb3322551813cd1f599dc9469fdac61aa5e056040a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e59ac2058e262574c33cdb3322551813cd1f599dc9469fdac61aa5e056040a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f9d52b36ecef2e116901b9d40246901b968e26ecff9a6aaa70f4e1131af5cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf177c425f7fe68cfa7d1002d99a3ff826c4679692fe49059dd25e43000ff878"
    sha256 cellar: :any,                 x86_64_linux:  "6d5774bd1de7608d93127b46bd5444bfa980c7ac96b6d0c5174301c91745869d"
  end

  depends_on "go" => :build

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
