class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.3.5/texmath-0.13.3.5.tar.gz"
  sha256 "6858245031f5d0247beff4020a71d24f5c732cc1be3062db00e8b185f677a212"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2de4dbcc793b561534acdee7554abdbb6d0c56df7801d8fce6b0e1875b4a1e1"
    sha256 cellar: :any, arm64_tahoe:       "958694d9953ce4f3c84cd38ea3d1a9d8df95f444927a5d5436578531f203bc0e"
    sha256 cellar: :any, arm64_sequoia:     "47855bfd566aeefce5a4998895e84602b8e9d680114df14dfb49937eda1b50cf"
    sha256 cellar: :any, arm64_linux:       "13a88deaf172ba2b053c1aebe7474f62907149cb7932a0ca6386a3a4a9dc5b99"
    sha256 cellar: :any, x86_64_linux:      "8d241bdd8fff7c3c97fef73008ca0cd568591a100ac9c8d52c2de3a3260c5673"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", "--flags=executable", *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
