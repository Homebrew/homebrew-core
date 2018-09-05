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
    rebuild 1
    sha256 "4170ea65045b6eb244b6f887a648853a1f92c3a95d8db2125ed41bb24becac46" => :mojave
    sha256 "372c28d50b8cee2b31a6c63c308c7ca8ecc9db5d0bb0ec235ed3295780762d92" => :high_sierra
    sha256 "ff3f24bc8d38042ead62820906b9907c3bd7fd3240ab5b309f579a0984a2af2d" => :sierra
    sha256 "3e82106d209775ec04a0a85bf99961d392a4ea22bc41644122959e5ca0798a25" => :el_capitan
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
