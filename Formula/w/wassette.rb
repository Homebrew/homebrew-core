class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://microsoft.github.io/wassette/"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "62a8b7197a3193c604fa4374619529e2ec95e1416017863625fe9b1449453c48"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef62c7ac5ad4d35d1341d27110d61dd581c599143237460b65d7fe3305c13974"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c00fb78d2effda46b3d6e418260abdac618dcdc239c202cf11199575db9b7c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81d4110b0658d2fc2c14fb978ff521161785034e8ef3a6710809fe0681e770db"
    sha256 cellar: :any,                 arm64_linux:       "4dad7b94d3d45624be3ce63d9d0651beebeeb956a84eb02238e1fdc8221fced9"
    sha256 cellar: :any,                 x86_64_linux:      "7c853a29092ed9c65efa7732e354ec427277408c4c0e232174e747c632ad0d7f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def crate_path = "crates/wassette-mcp-server"

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "#{crate_path}/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: crate_path)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
