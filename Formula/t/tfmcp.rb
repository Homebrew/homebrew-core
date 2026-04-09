class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8bae76f5d7db9bb2bc022ab4c356e733c9935c997a2b07780c7f129f67119c10"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c355d5a7c24463797e76ac30c24c69e7326c0eee9ee05e5ad79d3f427bd240f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8221c52c9bf701b7ec72b1aeb8ee6052e71a9759a48d7a3d1d5bb5a62b63e8d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d0bfc57276cd538a3c5bd48d9ee6d618d1f627b15e19f77425decdb6c418fe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8d7d25f30b45530a7beb347017df18da2a55b982e1e20dea20bfae71ce0c717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4bded53e2fa834ac80ded8d4d5d88fc85f8b0db811b23c7cac93fafcca342cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07654955edaf0f36cf25df4548dc3330c13e21293dc732ec87e311b94c7ba4cc"
  end

  depends_on "rust" => :build
  depends_on "opentofu" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmcp --version")

    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    output = shell_output("#{bin}/tfmcp analyze 2>&1")
    assert_match "Terraform analysis complete", output
    assert_match "Hello from tfmcp!", (testpath/"main.tf").read
  end
end
