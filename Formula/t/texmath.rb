class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.2/texmath-0.13.2.tar.gz"
  sha256 "6e6ef7b4a964d5c50ec884031916ede64ebb75dd6b0dc9548fb2e2dc757d6512"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8738f8f2723298443452b033ea5f09be8f227ed573ab068fb8efccda15d3ea62"
    sha256 cellar: :any, arm64_sequoia: "55076a06aa19174a76ff4bd18ed22ba259ea500847e5ba1f76878b49c5949d24"
    sha256 cellar: :any, arm64_sonoma:  "f0da3b65ece8ebfecf5e92e8393ef8c7635c2ff8f2005875595536b673bddc2e"
    sha256 cellar: :any, sonoma:        "96b910a84e879e39e44df06dbd6dfc4fe506865e342239ba843c2cd60fe1e31d"
    sha256 cellar: :any, arm64_linux:   "0aa8b3ae54dcf2b35405ed7d66e9d6ca17d15b82625e8982926c175b9e65d738"
    sha256 cellar: :any, x86_64_linux:  "f5e8084b99f63d9fbe4663e42679cbfe2427917a638ca6dad40c98c6d1caf886"
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
