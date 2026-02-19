class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.1/texmath-0.13.1.tar.gz"
  sha256 "6f9c59e767c4d2d14e9ff45bf82a70e41922065586bb03c3ee39e2219c39b353"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c626851aa43ad8e20d494ea773623b8f0c5d671feb6d803e634058bb30fda1b"
    sha256 cellar: :any,                 arm64_sequoia: "e00435e2a39f59e5a635cac67d983e12031639e81becf6d65b1442bc082905be"
    sha256 cellar: :any,                 arm64_sonoma:  "50e1dac489030514f891d52bd3a4b09681edc52c8e5655d193b35b43a47fc36f"
    sha256 cellar: :any,                 sonoma:        "28fb4dbe143f713f1f7baac2c6ca3a6fb4f97734a7458ebcf85d0b376e5573ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfd50d962a89098c6eeea6845da9fd85c6f04b23b3bf7f7faed93028771cd264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6928e2fda9738c9c8bac7c54f53f86d8720198178ce9dafa9412cc1b1f6238eb"
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
