class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.13/texmath-0.12.8.13.tar.gz"
  sha256 "bb51a51f69d02c7fed411739d61bff62d56865719542bba995c66e5abe96e409"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61ac507874076186d58c59a324d1085f89c3fc38055e8fccf0c5c6a48179c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263ebb962d84ab8982cd7307a338379ad3ef95dbdab9be432e918678edfdd693"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80a0b30a2313dff65f5a9598c19fee71e81e157a096b04103cc2c35f60bdedb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "394f37e9a853aabf4240b16997282a785625d0d54889e4c06b62f424158e4f98"
    sha256 cellar: :any_skip_relocation, ventura:       "c293a0fda69579585045a78c90343e21f4130c2b5f0afbda4e5957691e289437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272398a9d4932e640aabc6af7b830e7df9fc06410933b13c00fbba858a0bc8c1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2", 0)
  end
end
