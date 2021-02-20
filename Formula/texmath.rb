class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.1.1/texmath-0.12.1.1.tar.gz"
  sha256 "01be79d6722c53420d9a5c8d0089d9990689ab39c1d964e7ef3ea9fdd77a9411"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "cdc91e162794f7481b0b4d881b8217e7b51d7c1613d5fa73772fd778d1eac7c0"
    sha256 cellar: :any_skip_relocation, catalina: "dd439f733a8c27d6eabb310d73679e100ffef8de14f0f0a705ac5d715ada5164"
    sha256 cellar: :any_skip_relocation, mojave:   "1ac2b2157f436c43c9857b7506677fa875780b74a819127dcbbee2c83bab34be"
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
