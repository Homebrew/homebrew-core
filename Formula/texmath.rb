class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.7.1/texmath-0.12.7.1.tar.gz"
  sha256 "7da715cf40920a3bfe42a33e22cd627f7929e7454595984f8ec02e0ef760f342"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18ff3c6a4f214bd534b9a3d5b298abab00b208ae8a6c00f139eac4acdbf587b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e660c1473f2e0d4f028198341afa63eeaf71a0a6eac68825c945e78c35536f91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b577eca8c21bb3e223a8bc8edf32d8426badf024cc6526f6751ae0ddbbe2a950"
    sha256 cellar: :any_skip_relocation, ventura:        "080f0cbb1196a8f90f67a0f069f7c6f684933740e99bc4bdf805695d51afef9b"
    sha256 cellar: :any_skip_relocation, monterey:       "db3b62ceee0b3cf5cf380ec40c1043dfa6b22aca417139f1985e3ca1a0bf76d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "15cdcea6bf2444beb80170e06e10f24550b97d487ec11cafc7e581514423ee42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bfe2df57d2390d1a04e16494c39c29f5820f977c42e49594612c0b29d8fc53a"
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
