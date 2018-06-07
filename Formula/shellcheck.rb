require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.5.0.tar.gz"
  sha256 "348a3f7892c1f28a44f188c00ac82f1b3bf899d9f81d14ddb0e306db26c937bb"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a468d586d5a580d151dda95e361008dbdea38fe7a14ece40d79e609d49f4c74" => :high_sierra
    sha256 "c3fd9d53fe9a67cd318fcee6e871b9e46c10e550cac58d25be3d36a526dad2b1" => :sierra
    sha256 "17b2a30cc01429b182a07c04c4ea8b6ec1c9bf9f257d87595684dd31634f72c6" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
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
