class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "84255e60722620888b6742df56921f2f2762c74450d17efe5e418fd682644945"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43943a4cafaee84416c5fec9a4eae9d13f2c8e2b5b093be37d360e3fdd1d9ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43943a4cafaee84416c5fec9a4eae9d13f2c8e2b5b093be37d360e3fdd1d9ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43943a4cafaee84416c5fec9a4eae9d13f2c8e2b5b093be37d360e3fdd1d9ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe38456b2d9673330a1637034ac3db723292f0e9a1a5c50c923f43495221efbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5ede2e3dded083b30a683fec6812e3e7410d2c9f38964b48f64052989b1c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7f14c4685ebb6415444e6020d795290eb1564e1245d464cf8b1d7e2fb6ae8d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
