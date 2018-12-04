require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.6.0.tar.gz"
  sha256 "78f90aa8e618dc468bc1c36b6929216dc7a0c2679cd157e50919f7d8cc1899bc"
  revision 1
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81b8ae0765a9bdf7e90c6283bbff2254cddf3b32ed68c5f3e606c2d17cb249eb" => :mojave
    sha256 "14e1fef7046bd4ec1732e7cd17913be2c068257a975afd871d81bb20f426bfa7" => :high_sierra
    sha256 "5da7a525dbb81be76cceb0b326c4b524e2ec96c591075385899ab77c2f48465c" => :sierra
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
