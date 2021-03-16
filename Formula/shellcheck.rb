class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.1.tar.gz"
  sha256 "50a219bde5c16fc0a40e2e3725b6c192ff589bc8a2569c32b62dcaece0495896"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5ba3cfe883216a700c133e35c3f1612ab70eaca07cfb43bf6ed427b72dd7d552"
    sha256 cellar: :any_skip_relocation, catalina: "bd66df0992ced04f98883eada3f14e620f6c76f268cae2adb182b52d3bba1858"
    sha256 cellar: :any_skip_relocation, mojave:   "bcb393cf5a259c69fdf7ef1725243b48c5653b9db17d2cd51ad140ab2d7de9c1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
