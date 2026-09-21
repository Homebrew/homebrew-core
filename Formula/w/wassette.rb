class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://microsoft.github.io/wassette/"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "805dc0e3201694e6589a73dc6705b5b3cada01ef4c0ac7b532e140dda7bff77e"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23c36fafdd59ef7816dec82df30f800120af35904d4b8d284c731180065987ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f9e9095445555f612a10d213c04647370aaed2873f4e29f8bcfc1843802e8f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7da421696a75e178ca17737d93454c0bbd6d35435d7c7915c377aedd050781bf"
    sha256 cellar: :any,                 arm64_linux:       "48edd88d6ac2f9b716636038eb7e6e926b73c1cb0812fc11cf4c98b975fce9c0"
    sha256 cellar: :any,                 x86_64_linux:      "46d176d31bbfe369816eb2d598002205af629028ed57104accda3006e1172ff8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wassette-mcp-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
