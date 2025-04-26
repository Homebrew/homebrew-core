class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.9/texmath-0.12.9.tar.gz"
  sha256 "2e3454d672e69857c957d2b945b64de83a9f28b3c9f8d4beb6992fef3b908e17"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8ac8738583735b1ec82ff72b6f66f9cb8db5b5e092287b5d9cc2d987f30152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a1807646b8a13d54cee2e8083d076399284177d3cfa5706fe050fd3d2765f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19f1ff78f57aaefe59eb93c3791d95d066c41908655e3de0ac5194323ba20e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c689a50943c33ce98d0923c1565a9f2669e3e8f842f8ee1a47639a58aed74e"
    sha256 cellar: :any_skip_relocation, ventura:       "d5573e3fae8d93d830f2e2fd29c2b430f7f32bc14b86a92c03fcee26340471a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22aa1fac81b32e222f13e81d6a753022493bb3c5e85762e8c4e58a4256e1a253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1623d869fb7ae3b778353a8d2435e5ef979425d795e4bc0d11205e03d7860ae"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
