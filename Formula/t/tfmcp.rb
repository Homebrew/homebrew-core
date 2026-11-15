class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "9eb67399692ec7f5d188e4a42064157592286d6ad906c9e2736501f5d697b324"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b13a7b7e33962bf7cc11eb1cee0aca60e4ff7bd9dd8413c47b0832dacc12931f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc5090189f95811b5e7fd7e78eee084af8595dab79fbc4afd866e6a261cc56ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b080181f0bdbeaa02de7b183b08c34bbea4f09ccf059de9de11b7fb6eb409121"
    sha256 cellar: :any,                 arm64_linux:       "42737c0a9d274485d0bbbd7ffb2d6b890446ed703effedda6ef29c0b72151e37"
    sha256 cellar: :any,                 x86_64_linux:      "50e140548e6e4452a80a0e10f3655226f1cec56fa9d16e0bda6645706662d513"
  end

  depends_on "rust" => :build
  depends_on "opentofu" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
