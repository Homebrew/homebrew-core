class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.6/texmath-0.12.6.tar.gz"
  sha256 "6fc38a9e876650e3466e4167f7aa5242fbbe5a5f636528af1d6e607da913fe98"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb76190866e3670eeb44b9b7e04d99186cc2fd42630698d18f3e4d1f93247a87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37ab470f173d44dca955775b35315af0cc3b052a2f59a4addfba4a62ad66a4be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcdef4cc091fb5b84e89161ec8ecdfa930983efc528a9ce9c067ec4a88f5fa7e"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a766eaf751b79e2c5c81601bea2f873abb45bd48c1afc0be28a2dc9f84411a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0d22676259b923b8527a37b50d10f2873eaf3eab662ecc361af4e76b8bfed0"
    sha256 cellar: :any_skip_relocation, big_sur:        "029137ed88803647e3cae9df1dc94384b771c9cc97cab44427154c92537c1ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1262f24a60b22b1817e767edad3a704d6ca019e02366214ad3da0838491875f8"
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
