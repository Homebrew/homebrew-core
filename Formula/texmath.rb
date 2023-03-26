class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.7/texmath-0.12.7.tar.gz"
  sha256 "1b3e70bc2694fff2fe776921981df6210df79577cedb0e7f5371020e3a38ddc5"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d76fc042efb22c908c8721f9cf3293c7cb7a9f40b9f3e8af9b3a28ea5cda3b66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ae1584ca92079f7ee40fbd8ded055829178dbced42108b47da0c867255b099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ebf4e19a1f6a7a88bcb334af6a2b2fea74fa3355d0da30e9f8e35641f437bb"
    sha256 cellar: :any_skip_relocation, ventura:        "a5dbf57e471181dd8f23d35b4d49a13a59bbe94d4aa5cd57578fc2370d635deb"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab43153d89512ebc04282617331278b324a29f4d9e4c529c430f2ad42c7739f"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c2076568d832f09cc38a6560a3ffb92a26f9d3ad7c7084127432dc387660f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3698d1d0818a4347df69f2e77cf4733c63d3ca588b66018718e6297c0aa7bed6"
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
