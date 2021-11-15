class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.3.2/texmath-0.12.3.2.tar.gz"
  sha256 "d6ec8b7ecb60ca73d56d8043ec79a006144ab50645bb6124c86f5678941d39b5"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b471c89345030b451f57970937d314f89515dacd1a3a8624483e9c7ead6b1fa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2374d6c7a8858e0d005b81872b2e1b7c0109113ef594a3de561d4cd2bc8ff5a1"
    sha256 cellar: :any_skip_relocation, monterey:       "d010ba604cbc5df04ccc3a6469815dd67c7e9975af2420cfb6b4e6a43b13f294"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad0caecd1adc1f06e432ff9142365231cc5e1fdb1e98528d3a63f93bc89a2ead"
    sha256 cellar: :any_skip_relocation, catalina:       "339a5893be78ab0bdefbdbd167c46080b8769be0c5975244fe16a03ceb32dd61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad04d10c6f5ccee591a33987d8fa1a4c906e9ccbf0f4c813427129748cda6ed5"
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
