class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5.1/texmath-0.12.5.1.tar.gz"
  sha256 "a9b4c7b93840f5772a718b8277c233b813e2e027c94d735d2f6f498e21f01fbd"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede9fba426d612e361ed9c9a555df8626430705848762ff508cc2f968f8df1b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2de9e1e654e02a6a8ef31c7460a6b7734cbd7736d75133825d21531c92c5cae"
    sha256 cellar: :any_skip_relocation, monterey:       "17fb6cd730166f793a69f4f89a6525c4fe951430d7c0633427df1a02b61a1354"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dc6314da2349f54a25d80f4bac178ca76f902b2672a24a1ff43125190f416b9"
    sha256 cellar: :any_skip_relocation, catalina:       "2fbdd8536dedf910fceed12941303db12d116c84668b70e96c4ae0edcffd5c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae79c2d327212a2de6cac0e0acf915d8e6aa44c2bca365bc7d0dce99b29a468d"
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
