class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.1.tar.gz"
  sha256 "50a219bde5c16fc0a40e2e3725b6c192ff589bc8a2569c32b62dcaece0495896"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77e5385a84164971cd75df484031c79e41eab8454deede5b40b278859a039115" => :catalina
    sha256 "983f1eb4590e9be83584d68f5b7db13b3c3f2dbc50ad61b1896e8070e2e0d375" => :mojave
    sha256 "6f371407500c5bfffb2c44e69482c524d8cb96d682ce93d06d148eccd6e4d052" => :high_sierra
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
