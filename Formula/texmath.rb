class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5.1/texmath-0.12.5.1.tar.gz"
  sha256 "a9b4c7b93840f5772a718b8277c233b813e2e027c94d735d2f6f498e21f01fbd"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed600f2e7513a9d2088c7e879fc8733d98549514a5c8296e5fd756ac0eec533"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92d1f9cf8a146f823df8e65e725da91cd2231c3062fffca31276344f359a94f6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b188d7c94349878c51adfb2bae8e49e7ac92cee79edc91c9d5b0295a5a5d4f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "adeb9e4fc68e7f9938562b3d35c4c6645ca00f0e3f9fe01991da931f0a015f6b"
    sha256 cellar: :any_skip_relocation, catalina:       "52a922e07cac93971108780525dc6530ffbb75b5a69c19fe9da4d7f9ddbc66b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b377bef40a53dc0aaa5b0ff3ea59856b95ab741db89b209c6de5d7ee0ef884e3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
