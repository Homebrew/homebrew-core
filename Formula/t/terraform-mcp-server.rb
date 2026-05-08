class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "7f1c350360cfed54ab4cb9cc028846e37e9bf76441c7a347cc1037d8374f8990"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f87bfc41fc5020874084a58bf6ddeed58afaf4f00b5871461474efc371a17b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87bfc41fc5020874084a58bf6ddeed58afaf4f00b5871461474efc371a17b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87bfc41fc5020874084a58bf6ddeed58afaf4f00b5871461474efc371a17b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "86890a2cebd7a1eec8a11ce4a36282863908b957ccef7c65587c5daf03c5f74c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f11910c8d624a3039b9b568092535eb01cb18064297c845dd12445415527e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ca63aa090762f9b1d0e5eb7fcad6fea08c2d0df1c8390bc5600d024bf97c62"
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
