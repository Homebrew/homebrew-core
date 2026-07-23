class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5173256844065808262ac9a22bb60793527f7840193aee68414dccf1c6dc4d93"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58f34e50636724468f94b8d5b6dd710dcdc8b1455bbfc3caaf6d37ca4632d2ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f34e50636724468f94b8d5b6dd710dcdc8b1455bbfc3caaf6d37ca4632d2ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f34e50636724468f94b8d5b6dd710dcdc8b1455bbfc3caaf6d37ca4632d2ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ccc3999d5cd6c53dfcccc208b0871153f2280360627aecd5f534654763108b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df42cc2d5f808dfca784a078fe9929a3ee01948d0e4051afdd3068db25a06673"
    sha256 cellar: :any,                 x86_64_linux:  "a36435e770a65269b989e7a6257ec078914365c4cbfbea42d6ee340401193095"
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
