require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.7.tar.gz"
  sha256 "3fd7ebec821b96585ba9137b7b8c7bd9410876490f4ec89f2cca9975080a8206"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4670b4952117677a171f4e3312d5b6660ad6b443c1e2c65aed8fb17fe46b2342" => :high_sierra
    sha256 "8eb344f3f20995bd7210f12b337116b0295755bf78990ea824ba160e8e6b0bf9" => :sierra
    sha256 "7136c486a8faf29e840b96abc02a68420b641261ba3ed252fbc5ac0da7161721" => :el_capitan
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
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
