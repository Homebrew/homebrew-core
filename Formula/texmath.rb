class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5/texmath-0.12.5.tar.gz"
  sha256 "697a60ab7a658c24266ed3d4e82a4960c42c85f94e24cb851004ec01d406249a"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d378f0da033e241105b60fc78f00353f473801d3e65ec4f97c3164d7e00ba9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "502447a67f42878d59de604e8ed6407e5f9b5aeebc83a76735daccaffb73f139"
    sha256 cellar: :any_skip_relocation, monterey:       "38071c1bce3a47486f4fa12dc71bebcd03381092aea02fe22da51d3a2566f45f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf6c3426a1140be297313d5c3dd9866424c896426a89b21206cd5e36b083764"
    sha256 cellar: :any_skip_relocation, catalina:       "85b7f4f74bd19e97531ea774c54bc1be9a80da775527e76a254f3e7c4a8e8b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b702cb496423536ec348153a56f6f3f2577a21308296469dd43834b23ccb52d"
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
