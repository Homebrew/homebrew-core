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
    rebuild 1
    sha256 "7b53bbdd68a4dc010bbcb36c0b7b25df780f5f0f26454996688a16a7906be603" => :high_sierra
    sha256 "a481d31443ac152caadf1b43b95d1b509a9070402171dba1570d11943ba8dfdb" => :sierra
    sha256 "19b2be242da07935fb5393285cf87a4ddfe4cd9fb2aae8f03cfc856bcefe0140" => :el_capitan
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
