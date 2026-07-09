class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c214d0d6e49fd87ce0a1bf69d1b615495d6ba99f6659626339d08c47468b2a3c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a813620963917bd6296ad9d6eee4c53fd13544fc95b848499907f810cb5904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a813620963917bd6296ad9d6eee4c53fd13544fc95b848499907f810cb5904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a813620963917bd6296ad9d6eee4c53fd13544fc95b848499907f810cb5904"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dbeb96650d2df8711d34922183e832aa103ba69be3fa79a4bfdd4413b71f764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b51c32f38f805c3d1603621d90c5d0923becce8b4c35a54cb524b5c69c5fe5f"
    sha256 cellar: :any,                 x86_64_linux:  "d11ec4e80676d54497105b3e4c888b7435fbd13fc51d9b5ee945b94f6ceb4b89"
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
