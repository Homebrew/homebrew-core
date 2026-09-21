class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.2.2/texmath-0.13.2.2.tar.gz"
  sha256 "27221986436d75b8464adf5f632ce55fa782de26a32d8362f509506531fa8e11"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7bdbe53e65edc3404491442443e7c4fea80e668418d3c94bf8a26a205229ac25"
    sha256 cellar: :any, arm64_tahoe:       "2b795d4331c7584b1e02c1dbd93394d90cf99d54931b97ef6dc0423b20e1bf34"
    sha256 cellar: :any, arm64_sequoia:     "32729630b3b3ab38a3b9810fd7a5e3d6012b879f965966dca90b442b2635979b"
    sha256 cellar: :any, arm64_sonoma:      "8ca7c861d4969d8ce5cd59dc856b3f1b5385ea9b6734e9e719c4cd2f056934c5"
    sha256 cellar: :any, arm64_linux:       "197c050dde531338905ff000ab8474ceda95adb1407058aeedd9281d328c2ae8"
    sha256 cellar: :any, x86_64_linux:      "ba138e6d3ca44cca1e0c5ae6bb05a0d1632d82f902c5da8d30440a0227eb8d54"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", "--flags=executable", *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
