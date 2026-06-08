class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.1.2/texmath-0.13.1.2.tar.gz"
  sha256 "25660b359021462acb5024c96d45c7e83a50ea1ae1f2a06e89c1941851fe4a10"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2a4641b390afdff1bde2f3a486de6b49cef41d7b69c0b0e839ea22b1225df1e8"
    sha256 cellar: :any, arm64_sequoia: "bc279b4503d55cf160411c0bc29349762efcfa3dd24eb869f68c36b11c14987d"
    sha256 cellar: :any, arm64_sonoma:  "31a5e7ef5b25dbabe9a91a418242f9ecb2695148caf3647b0bae8ae6f214e88e"
    sha256 cellar: :any, sonoma:        "f0afb4aad9f89b89358a7af1649589fa5887f4ca5ca263036dd8b4f45a1de9f3"
    sha256 cellar: :any, arm64_linux:   "2b2c8445b068a442a43d07e960b4a48113a29fd50019c3fa50284691e358349c"
    sha256 cellar: :any, x86_64_linux:  "70e7b21537f5ca626c161837222fd099d6dbdef1f05e19a4e57848d5166882a8"
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
