class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "a7f41f6e570fa4512e14c341073faec8206ae21998b135ce0da8bc50dcf7b3f2"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4d054365458568e0890ed4485317fb01d1b0f63d159c89cf69e90e22db523bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a383d95000bab1e4f76a72f7e24b09677c41d6e73bd7e8d13aae23dca9e09fc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8622fd30478fb8bfd284b6b45de1db412ab50d5f42ec22f397e81dc71de60645"
    sha256 cellar: :any_skip_relocation, sonoma:        "b109a5fab2069d3c6d6a089893d98af6d91cb470ef2a3d9e0c572c166561887d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7058b7da00775b347b19ad369260aad5cb87dd02f5d83f9355a3c677c0f09246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3c9b3fd78744bb4040c4682bcde59a914a26ed55e10f3b5fd0670541c8c8ed"
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
