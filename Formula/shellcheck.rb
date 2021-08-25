class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.2.tar.gz"
  sha256 "5911f6133951d0ba6d643025bc50f2afb6c6f66d7225dc3d42e8845bfdf74c3c"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd0848768936bd45e983360e8c3a08ce66b23d1fecf10581b76a3427a282941d"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd11c23dc7b8247e976b0df0cfde0b2efe27ce86ccaf41f7946dc63da42c1e9e"
    sha256 cellar: :any_skip_relocation, catalina:      "93daddfdf6d5a6eb297d4bd83ffe06042b8821e37151801d5b1b8e90424d267b"
    sha256 cellar: :any_skip_relocation, mojave:        "648862ca99ae45e54144d566ef005f23bbb5ec6ecd1138bb61758e4e169e37c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ee41927c0f877e5d5c52425abde66e2da5c284d46ff3a8b561f57a41c42e20"
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
