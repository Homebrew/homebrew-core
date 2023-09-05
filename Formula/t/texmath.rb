class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.1/texmath-0.12.8.1.tar.gz"
  sha256 "6bc64f44e6264b2e8cb36d21985f00ca871f8859bf335588663cb648d0c84e7c"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c320d06b473782738b3285083bb13fd82c476f3a1d9062de3c97639658fff7a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f4c823da365aab21e08ad64de03b767e3d4ce8ce236153d2a2ef3a4c7056e6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1418bc87b15a475aecee5b27b8791dddeb075a863bc3a56090055a382546e127"
    sha256 cellar: :any_skip_relocation, ventura:        "4b516e4ca54fd48838311cee0768a7110ad748baf5c7a8e484e5f37ea9daef4e"
    sha256 cellar: :any_skip_relocation, monterey:       "88cd1bfbf6a1c375caf1581bc22782406b1246a35a95e435d4749f24e818cb40"
    sha256 cellar: :any_skip_relocation, big_sur:        "1641849be86ddebb1c3f1e525b1224534f5b1cbb3d8a1e57ddbbd3360d043844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a3a5868f7299eb8c2720ed0f5ab959c40cd9d383627320df346abaa8e005d5"
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
