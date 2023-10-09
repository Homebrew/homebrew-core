class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.3/texmath-0.12.8.3.tar.gz"
  sha256 "f7274bfd7d27eb535aab4ff125f8ad23dc4e84763bcdf8021429f41f01dcbf52"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87f739c9a3bf5a1278c2805de5e55125e333c3159a6781fddb5c95c0e5fe1303"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "175f9570613a29224f53696cf7622b83924a7c0005fce0af3431f5019944299e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64041dad5704097a7df4eafe8d99223da61dc2091d6cdc9cffb0de66dc3bfbad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8cd88312ef3647ba1266d8f38766e3f7dacfe4ec5874a05d94b0584b1e555c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "50ff1eae28eff1456b8d257fe070c8e49af72a8742a5dee93a1596a027f79db6"
    sha256 cellar: :any_skip_relocation, ventura:        "886fe8c55cfee61382a048a4318ee26d01cfa123546aa7191c4bdaebc1f713fa"
    sha256 cellar: :any_skip_relocation, monterey:       "ea671d46e6ffcefdea047d3e3062e761a16e0f991e90d568c5d1030100c32046"
    sha256 cellar: :any_skip_relocation, big_sur:        "996d7da7379c0316cb2414e0176d69ca77db16612284bebec66dfab50429a4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553b59412e5ed9a441fe10e6e22dc8f83470923296f6c6ec094ee00c62feabd0"
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
