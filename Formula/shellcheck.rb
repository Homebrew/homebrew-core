require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.1.tar.gz"
  sha256 "50a219bde5c16fc0a40e2e3725b6c192ff589bc8a2569c32b62dcaece0495896"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be8e084d55379a4b5a8bfba78ad298f966f0888e6c3eb7e5202527d3938f3501" => :mojave
    sha256 "a4e12db223139c82649fdc16a2d04184cbaf5fc413c1135b0a1100a16e33290b" => :high_sierra
    sha256 "770a22a491ae6316f7b6e56d8039d30693d857336ccc608de865750798480899" => :sierra
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
