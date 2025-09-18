class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8b07554f92e4fbfc33f1539a1f475f21c6503ceae8f806efcc518b1f529f7102"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8c12e69512ed369ded8a58cfb81c8d42eea53d8ac51119fe3f83e050e6a6f4d"
    sha256 cellar: :any,                 arm64_sequoia: "8cba28650eef6739b81380743c58c323a8846c6ff1cf6fd730e434b945244e5c"
    sha256 cellar: :any,                 arm64_sonoma:  "606603b04a41787ecbafc31c4e769e190719e9a24fdd3fc181e7f10ac92cbd17"
    sha256 cellar: :any,                 arm64_ventura: "55dc4f40dd13d13d1075910cf0791344f3d9018d04d6fe5c1686710829354d10"
    sha256 cellar: :any,                 sonoma:        "3608bc5b421ad7cd939f3a8e3268a3c8f6369948ed555afb9d269134a0bfabe6"
    sha256 cellar: :any,                 ventura:       "31533a851f7dbc8a808a0787dccd80ce0a22e30c099b49e5d588ec555b3d0d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b6289eca1e028a336e6090a7ab42efb47993c51194941c43fbe7d156f9f4270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e84559495ee8f9719be30a9d8139a3016d2f448d31fc79ac4d135ab86a228404"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    system "./manpage"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~SH
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    SH
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
