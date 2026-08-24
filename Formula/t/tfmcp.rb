class Tfmcp < Formula
  desc "Terraform Model Context Protocol (MCP) Tool"
  homepage "https://github.com/nwiizo/tfmcp"
  url "https://github.com/nwiizo/tfmcp/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "93f88ccb7a24650a37b238970b045976ee6e5f8d2c48970c2d4793ffc692ce80"
  license "MIT"
  head "https://github.com/nwiizo/tfmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e667b05fded7e73cf3c00bb745e841a7b5958d9b4b7f5995df07ca050b99aa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e693fc0e5a20f234134173130a0f9f63252c1a0881a7f688dd59e25498813f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9e428d15255272a4d5b584beaef71a5f5f2b22be024c104105f4371bc37da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67777c5a67af4ed048b868130d0b00b8f3048cf66ba67c451559f14814b7b62"
    sha256 cellar: :any,                 arm64_linux:   "503663e4be4a0743d3874fda90ca372eb47728cdaee2dc915d8d7f5e7b991563"
    sha256 cellar: :any,                 x86_64_linux:  "392a4cb09a5cd4d52ae13218e36e03917322aa8da730a361cdd94b09570fd924"
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
