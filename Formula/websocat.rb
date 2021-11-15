class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.9.0.tar.gz"
  sha256 "8ad0d3048662e321af11fc7e9e66d9fa4bebcd9aefad6e56c97df7d7eaab6b44"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b76f7fcfa4ebf2fc23020f7e22e2178c68b8b8bde73f6d371d3e817add5417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "309a57a8fd36a1ee4cc28d21b30cb9769685cd028ea5a8f161afa95426f7ad19"
    sha256 cellar: :any_skip_relocation, monterey:       "9383054678af18337eb65c00e3d7da5017b1b8747a6f942b421e7f455635a5a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd31927b25c9299ba56b6a24d5f6c2c0c8aca50262e88773ef66c031504dc812"
    sha256 cellar: :any_skip_relocation, catalina:       "ea7f615a79ec40a4cd93ed14d76fdc12828b0580cdbbfb379a395a447e5a4b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5cd5ef6f8fb29e5a8238d9b5486083363cff22cf2b96676835a2fca7ca3e14"
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
