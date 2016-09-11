require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.4.tar.gz"
  sha256 "1f558bf3e2469477e260f8d2edcab381a9b600b01d0f6498f8a2565965d75407"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "9b892d9bf0ec2b7ba2a5b117f1ab0fc54d2d95e9fa1f4ecbc92f44a4306aec6c" => :sierra
    sha256 "798c1d8b536aca0f25b51656e5d97bf7b15d499ccadabb81cdae6ab945d637ec" => :el_capitan
    sha256 "87e95a3d80bcd72c3f6209dbde585b080fb89d72181fe529c6286ac5d403337c" => :yosemite
    sha256 "96be49df8c50dbd78f4d32f534dfd78287946ddf1849f348426c6dcd13cef2eb" => :mavericks
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
    assert_match "[SC2045]", shell_output("shellcheck -f gcc #{sh}", 1)
  end
end
