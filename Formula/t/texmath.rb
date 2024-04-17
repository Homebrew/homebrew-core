class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.8/texmath-0.12.8.8.tar.gz"
  sha256 "6cc57b1a5fd5fc6b315885408da32fa23d28a14b7bbc983f3d1b1ca8dd430972"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1db04914df7e7839b8b91c6a8777780e692194ca8f12a58f905cd43bded708f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abd3508d1d3b6a0d87abbfa3770dd961f056c0b517bdb93e2c42d732ca82ed24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aaca290916a416093614a49191b83d68a35091b0eaccd0ffabb06a1886fcea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "452a09795594050d11f082f66481451720005145857d08ba9cef920ddcef9d8a"
    sha256 cellar: :any_skip_relocation, ventura:        "c4cec3bbc87ebc653f3156933a0af136b280ed80d18a2a1029b044dbccf543eb"
    sha256 cellar: :any_skip_relocation, monterey:       "93d441fd3d8fd9cb1e44d2082effe2c0b9257d8fa0871ff17d60d5ce19304be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568cf580dc67b0e445db6eef3ae2ca188d43427a0076cb3da130beffaa03b000"
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
