class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "4be94ef2a0779e679506cf83b200638c1073cc9718fc6a9125712eb8d5000da5"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b26da3e94858028502be8763989e36185c45f33a491c6df811f603764e89b32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ccf9842e3b1a9c63dd0fb73f170313240208c33386ddef74ea17c84dc44344b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d926be8e8de3fa27550a5d2e82c9500383ce54b7d942cd33e01035c947595d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a96c3ea440cf111eb6e7ec764208eff58b6d03f93ad466e845cdea72816f062e"
    sha256 cellar: :any,                 arm64_linux:       "ac5bc598eb4e500afa4119ae236a7f4390e8bf48b3c164000f7657deeb878206"
    sha256 cellar: :any,                 x86_64_linux:      "e07f68fa6c07836228917594b67a1eb2f5d08c420badaa7b7f2e9bc045e5c28d"
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
