class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8b07554f92e4fbfc33f1539a1f475f21c6503ceae8f806efcc518b1f529f7102"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "102f7f385855df8eabf5c9017b8d729a02a5ccca810aa23e3ae700a46226ab70"
    sha256 cellar: :any, arm64_sequoia: "7fda74bb60ad4ea2b2a7a6f75ed9d51457a0e238a6abb8c91ad7ce63f4d4d517"
    sha256 cellar: :any, arm64_sonoma:  "d2ac9b6f5dbe2917337c850cf36693e9055acbe01d9f8470b351227f00c01c9f"
    sha256 cellar: :any, sonoma:        "e6bd050611cc5d144bda375f77b047a8d5ac4546b35b5438a02a1f25269ce7e8"
    sha256 cellar: :any, arm64_linux:   "681253c23aa52c9b6247583b0511ef073794139edf47bae138d148f59a192b79"
    sha256 cellar: :any, x86_64_linux:  "84c28a6b4fd596e784c0d9a2ae24ee349c5499682faa017b969b58ea36ea43b7"
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
