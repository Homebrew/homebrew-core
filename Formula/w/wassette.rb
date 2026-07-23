class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://microsoft.github.io/wassette/"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "949d7a5541c58bf0ebad35213b233a6a9e2f95cf70e89294862ac2f2662d2f33"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b31065340f948e3dbb160e8b14fc2d787f7411c761a5796c0835bf3cc184e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e7c01e5c302d044ab93ba95f39edf19e431b10778826fd9cc93f81dff644cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b698445146c954db277dc0d8949524bb517b22a2e6a672988348dfa335bff818"
    sha256 cellar: :any_skip_relocation, sonoma:        "256a0813be8d18c75005883f2c83af17d86ebc711eab332cca9baf90d1f8217d"
    sha256 cellar: :any,                 arm64_linux:   "25c6965dbda1c6d952812e94104630bb91ad9a4eecf563b1085b05f0648a4b3d"
    sha256 cellar: :any,                 x86_64_linux:  "bce5ab85dbf846d0df51b662511ef01a634943b176ddb32c943e7820239258a5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
