class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.0.2/texmath-0.13.0.2.tar.gz"
  sha256 "7ad3064b787afdd14d2c66821120d0f30a1fc71100145037e108436ff3318bc7"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a5d5d84cf5ccb24e58a216b2a6acd6f74d97ac396d2f1b76da20a9c92c035ff"
    sha256 cellar: :any,                 arm64_sequoia: "f7774319aafe09236d63b48fbcdd80bc1fbb3e1aa4952ea519580f5fc17eb5f5"
    sha256 cellar: :any,                 arm64_sonoma:  "8cf6b5698768d57c399eeceeb715a959c22b2e659a5ea6a2f3d9e9d25b4c8139"
    sha256 cellar: :any,                 sonoma:        "132d0af3bc6a7f2d49890dc24c965d47439340333d647137043c7ab25e8fd4d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7a21ef6a40122cfec39c7fff91c60b2ae798db39f772b3f7d417d55deb2f0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3deb57c6d065246aa8d43d8da21b74f7ba679e63296d03cc4cb24967e83e8e"
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
