require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.6.tar.gz"
  sha256 "1c3cd8995ebebf6c8e5475910809762b91bebf0a3827ad87a0c392c168326de2"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "fe831d4211a25efc853f40d54af8bdc11c9b537893bb3f50f2267e841f414b06" => :sierra
    sha256 "4ad4491e8c026239e0f48e1116bf8da972957125d2c828ca6453e178dd13fe16" => :el_capitan
    sha256 "c5de7120093578fc009269bd83d8c99eea0f070aef1e026219d924113f150570" => :yosemite
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
