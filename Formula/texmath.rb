class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.3.1/texmath-0.12.3.1.tar.gz"
  sha256 "71b259b74ce60b81ae7fc520dfc06f2ac9863469be2472c901871f98168cd1e3"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46ed72e0b0dfa667e734bef3a4d82c544d75e070fa553eb36fd226b4ce5081d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "f61a2add343ea013338911404df8c8430c35a6eb32ee30898b541619f8bdad78"
    sha256 cellar: :any_skip_relocation, catalina:      "570f9bb16277e48262e8e35a9ed290ce9ff2b29801069d452d77128667e991bb"
    sha256 cellar: :any_skip_relocation, mojave:        "db017fcc57b938920ddaadd5dc672812b24d855c5d23892a7bf0e5f93fb42924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5646b903efee5029614c5672bf6e4bdbfb77470f68a9011994c139d80e381f7e"
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
