class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.3.1/texmath-0.13.3.1.tar.gz"
  sha256 "48bbd445d15c0b9c1fc8580b07dd8f38fa712167fbcd19fedeeddbdc60137da9"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b73fa36e50f20f56f4ae1c10e7241df4c9aa60305015aea15b6e71ad9eae1d92"
    sha256 cellar: :any, arm64_tahoe:       "4aaff0b3f0e6bf1c596b7c6923cc9958287e551b10ed6094df580b721ff09ee6"
    sha256 cellar: :any, arm64_sequoia:     "abf2ec68f2fb00cfbdea37f9583855d92a898f6d99ec1faaf3a60d0b257de810"
    sha256 cellar: :any, arm64_linux:       "a1ed87a5a6e6965a926393efcfab0c2ab55b4f6b7943addafbaeed8f9c16714d"
    sha256 cellar: :any, x86_64_linux:      "b68e3d9f45a9bb4a9cff554cb40ac3e0acfa9fcccdb36efe2202dbb6827fa19d"
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
