class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5.4/texmath-0.12.5.4.tar.gz"
  sha256 "98423b2e07d90d3f50afa7cd4755c8e65bc8712db248ba030bc478518646c8b6"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d57567aa453594462b8b93e16c7851646a117e410da6427f2e38bc5d460b4052"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a6492780d0f3111441313863c0be857cde1cbb65b546b82f43587c00a42df82"
    sha256 cellar: :any_skip_relocation, monterey:       "aac7b9048ab3c5c0b7e79e1ae690fc1eb94fdbc620133d5d8cf2f4f1af359afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f802665e0a3b6a40c4808a0d39ca99a59a2e27b89ee0fa57cd4b82467590aa02"
    sha256 cellar: :any_skip_relocation, catalina:       "804a24a3d75187f5194695c6c0f8ad441d336b2d40ddb99b257b4315da3149ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "868d5c1811cc34b3a015796affc1beab115062d87a2a48caf7c258c1a14a2c8b"
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
