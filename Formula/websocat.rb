class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.8.0.tar.gz"
  sha256 "f70b64f0e398f0e8abc2a127b5f1b3380d88ba3e375de8fd436b58705024958e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ffdb0bd4e66151c2cc813555e7928f08a82e79f399e4d6c039c3da15ae4a4a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "230d40f194ed076de696840cb2f7d56132da9ade368b89f9bc45048137c7852c"
    sha256 cellar: :any_skip_relocation, catalina:      "72040f8ecb961dcd3a88d561d63b4ee1a204bdd790bf379674d57ac47db31087"
    sha256 cellar: :any_skip_relocation, mojave:        "b96be1b018e195db5433a33db0b75ff6b34da210f3ee402f30e929bb0ee84e46"
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
