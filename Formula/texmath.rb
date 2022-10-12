class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5.4/texmath-0.12.5.4.tar.gz"
  sha256 "98423b2e07d90d3f50afa7cd4755c8e65bc8712db248ba030bc478518646c8b6"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e2d0ec6aa30a0e2fa85dec0764171ff5efd21e3197e95ebfb44d8b0b7d5dc5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4af5f9c1661d7b0e71921814f23bf608a7615ddec5448611732580a8a51b614"
    sha256 cellar: :any_skip_relocation, monterey:       "e93e3c25d32d849dc5fb507480a2f3f4d41764ba1f2a65a268cc52e7d3a06fcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "20dbe6697d9bcf5fb6ca9e49279d454f6c5f8dcb77b66c0acb402e096a7fe658"
    sha256 cellar: :any_skip_relocation, catalina:       "e1d28b8520108a4b7fe3e1164b7dd2ee64bb87890177776fae57c7d0260d7b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc4056348f6582c01b33c5f065bf8532c969b044057f3ab16bcaed02a4b2fec"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
