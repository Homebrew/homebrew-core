class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.5.0.tar.gz"
  sha256 "3ffdb25e937095d95b564eafd805cb7ca141570f95c1296b6dd336d4d016445f"

  bottle do
    cellar :any_skip_relocation
    sha256 "623dc7846122af9e51e163a4de9ff10bc89b47c15eacf58b8f6f9d39f528efde" => :mojave
    sha256 "e6557924fd0c2b6502425045bb85aa20a939beee8741111763f61420b4e6c17b" => :high_sierra
    sha256 "486878ca9cf0a9efae2e70e9af2013aa5ff882d2e172afc58bfeeb5de3b0b4f1" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "ssl"
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
