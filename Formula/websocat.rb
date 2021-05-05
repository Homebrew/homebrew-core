class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.8.1.tar.gz"
  sha256 "ed4ac1aa2605c5985482002d201114f30b4998b8ba247aee86103f59386a4aed"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1532c9c0f121e3167c1e065a139f31a353a2d1a3bece24c4a7b1e42a36851f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5d81e79d8f886a77dbee4ef883e775ea1661cbf38b340bd44d534293b712348"
    sha256 cellar: :any_skip_relocation, catalina:      "62e92da265ed936418268bc363fe990788593d33ef62d980d0bbc7aba440d418"
    sha256 cellar: :any_skip_relocation, mojave:        "dfc401622752756049f39b46cfcc9b3e7d66acfd6a0f4252d41d317ad2f8ec73"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
