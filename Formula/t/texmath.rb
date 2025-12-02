class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.0.1/texmath-0.13.0.1.tar.gz"
  sha256 "a31b24bac9f4e33e72af77608f89aa4f70e5ed356576e9b91e95d2f0078a08d4"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9f08c196f74d7b4882440dd942b6d529e88d3438b0ec127f30a4834ed1de8c6"
    sha256 cellar: :any,                 arm64_sequoia: "2a93a8c95e6e1bbfa40f5f03c1f41324da5a18d79ec97f815c0d6b442987177e"
    sha256 cellar: :any,                 arm64_sonoma:  "5c20352d200aff898e62798346847559cc002a1e1e689d0c17b2fa0ddb999fc3"
    sha256 cellar: :any,                 sonoma:        "13892f62af010342ccd32805887c81f4817ba02e339a6ac99c7da8fea3c3bc87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3da00d11f7d5aadfa19ef90b424def2af6c661c63283fcec7fc391bfe63569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1c70a62fc647f295595b78da71fa0f3d8a24d12d441dad4c512322728a39ab"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
