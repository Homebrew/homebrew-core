class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.1.tar.gz"
  sha256 "50a219bde5c16fc0a40e2e3725b6c192ff589bc8a2569c32b62dcaece0495896"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0cd635d2172d5e6617be8cdfb2723b6aa6feb2aa22e36cb3172d8b6fa012f4a0" => :catalina
    sha256 "37201a49c0d7a5be49c5d97d4f6f8f5fcfef7d700b4694f74648a1addcd6783d" => :mojave
    sha256 "1b20aeaba4d5e2e3df5cbe27636d655b6f877ee05a41d25fe1e0b3f9d00afa81" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
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
