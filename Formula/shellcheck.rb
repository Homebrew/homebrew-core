require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.6.tar.gz"
  sha256 "1c3cd8995ebebf6c8e5475910809762b91bebf0a3827ad87a0c392c168326de2"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "3981e4c97f80caa26393d3f935a227741a9c81b7a2df63a0e3708801eeb0cef0" => :sierra
    sha256 "7d5ffab5c7e530e369b428caab2285ed4dfb2deba034e6f8fadd7389953149a0" => :el_capitan
    sha256 "c8b22afa52149b48b9e58c60cd200b937c2e9b3ef12abb8914c7f6c31ab63e43" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<-EOS.undent
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
