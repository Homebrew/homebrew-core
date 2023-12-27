class Tinytools < Formula
  desc "Monospace unicode diagram editor"
  homepage "https://github.com/minimapletinytools/tinytools-vty"
  url "https://github.com/minimapletinytools/tinytools-vty/archive/refs/tags/v0.1.0.7.tar.gz"
  sha256 "51dd2128eecbed2bfbea2c31d9f8ce6de5c9d83c6f7ff8c39c752d0777caf90d"
  license "MIT"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "icu4c"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match("tinytools-vty version 0.1.0.7", shell_output("#{bin}/tinytools --version"))
  end
end
