class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.2.tar.gz"
  sha256 "5911f6133951d0ba6d643025bc50f2afb6c6f66d7225dc3d42e8845bfdf74c3c"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "516df7bcc8d5b1e7e4b989b472e89d9e3cf5e4dfc977aa45f06c0335c697b77a"
    sha256 cellar: :any_skip_relocation, catalina: "d4ffbfe9cb1fc1c888c7b6805a6c224810e4137c0bac0aac3041733bb36b7d79"
    sha256 cellar: :any_skip_relocation, mojave:   "a810166fde56298431a942ec439d5359e871a0727b989788040608876b519b07"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "llvm" => :build if Hardware::CPU.arm?
  depends_on "pandoc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    system "pandoc", "-s", "-f", "markdown-smart", "-t", "man",
                     "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
