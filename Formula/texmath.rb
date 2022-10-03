class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5.3/texmath-0.12.5.3.tar.gz"
  sha256 "0bd61fa5ef63dc3cf912e75ec9f24df4802d25790529b81a36ab87271a6564f3"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8148a6edc93d707170e432b93375740f90d1dcdf633c78732cc9eabc5ed44953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32e5646b41724c6c9783806fe09a3fe4e9b6fadea39991ed756bdae7051f08eb"
    sha256 cellar: :any_skip_relocation, monterey:       "113b22dc9fc5f6e8f96738f67325b18baa47942ec89646a3226d1cc57e292e10"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4f9e468a0072856d1e7f5dab61a6f5e1699881c862064b7c5d9d1df1d9af036"
    sha256 cellar: :any_skip_relocation, catalina:       "cba74dc0e4fd05bd102441b557224bb58a2c7f1e254001becc685d43f14c61c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4af06fb5e1031316e9e2ab40a9a92b03e85fbd40e2bd9f1806b055e047cd175"
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
