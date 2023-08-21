class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8/texmath-0.12.8.tar.gz"
  sha256 "034ff00671d9b8ac4c983df59ccfb4f39fc7d8c2d19f1f39cc00ac5d3f8625c4"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302844d08569c6532ed827efabc376a39d4179199ca2f0789cf2fad6f108da1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cacc39f4ab15a39a104e3b8d87bde61ff83e7ead099f7037565b7fc16e401de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77b9133fe460fc5607ecaa0a06ba1657f1e8a133ae21b18a717b209e27e00397"
    sha256 cellar: :any_skip_relocation, ventura:        "539f7a65c74e358da9bd055a529b0322c14506aa0787657321709b84a665e878"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6c832e0dfa18b2037804448b54049be05069af91becda57295675d76efece8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c31689b4ffd4ed3d7caba6152b4f807fa0feb169017d9db0d831ac2d31fa6843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a286826485c6e805e44dcccaaa4dd23ccef6eae189dd596d3e9a21b200a898"
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
