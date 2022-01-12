class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.4/texmath-0.12.4.tar.gz"
  sha256 "4373bb9db8f977f37b9c1316c65ca97bae7600277e4f79d681dabf2fcb81f0cc"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd309254d09195d0e4ba97524e9e04c90e3908549c34edda349e97d43c6beb44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9c94034cf4beeae96d1b3dfad6296e5dce855dbc09f9b4b4f84ae709d6040d8"
    sha256 cellar: :any_skip_relocation, monterey:       "0000aeb75eb82fa3579c408ae160cf5c086cdc384b3024ae2724392f1d0c2ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b106414d482730265d80ae31920b336446bf11bc894967d6a5d721c43d600061"
    sha256 cellar: :any_skip_relocation, catalina:       "625411f1d3d42c8236c28f3834a496722eb79a6906219e8358d5e40b20fbe9a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12145edcc663839ca6a48b9b3c45116b2c481ca736cc948309c0fbd0ad7c4d3c"
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
