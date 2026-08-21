class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.13.2.1/texmath-0.13.2.1.tar.gz"
  sha256 "f22ada32a18d1b4a50b9636073eabacd2ec6c3c2e98aad7a5413b20f4e9ba26f"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c6481101e4e7e2c2aed5799373882c8218a80b43e843c82dfa93b96ae5725ca3"
    sha256 cellar: :any, arm64_sequoia: "434077aef261750db743e0d23d913bb09c26cb208186bd0271bf160a31220f5f"
    sha256 cellar: :any, arm64_sonoma:  "53c7589f26ff7ebb6df422ad381398f8397508d6f582b5b890635e8e9e3d7068"
    sha256 cellar: :any, sonoma:        "172067c8f5efe01fad2a12571cc2025db5e0a6e56a6cbd2c7dd7af9b9c75e6f0"
    sha256 cellar: :any, arm64_linux:   "9664ecfba44a45e4fb6cbbd930df3bc047ffb1516c32200f55a390885d8adb56"
    sha256 cellar: :any, x86_64_linux:  "2f1d4f321d044cba4e4d569e33bb976c3309ab7154797aadd7276929b5415de3"
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
