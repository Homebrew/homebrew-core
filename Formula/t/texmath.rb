class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.1.1/texmath-0.13.1.1.tar.gz"
  sha256 "06a1d4dcf5285429592bc57416e124f90d215f8dfb09618cabc3d8d23efe4473"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d2cf90572b0fbb6ac2a1bd1298ac7dc37bdc856ddeed255bdd32ebe66b6e43e"
    sha256 cellar: :any,                 arm64_sequoia: "6717fa48f033ffbdb621c3207459905c5a729bf817166be38719c491501c530b"
    sha256 cellar: :any,                 arm64_sonoma:  "950dff3f42e3f06ef66aae2315fc4e3b8fed55a2ee63098bfcc1f0a952b099ac"
    sha256 cellar: :any,                 sonoma:        "54a87fb446118ed69ae86978522b3efb1927c09c85c2ea81f3d1bf2ea6c263d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26db94c3a39a42ed99b5a40eb8e3e9b568f3180005eed8b1066c7c74390d7188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bd86e2b11d588bf39b1fa94edfd5843b73fd10b7ad28b743e6701be4d0effc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *args, *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
