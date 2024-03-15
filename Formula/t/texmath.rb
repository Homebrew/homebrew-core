class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.8.7/texmath-0.12.8.7.tar.gz"
  sha256 "d33c332e21c8b4737fafd2a7753d38b67c6c94ffc44fd3dcdbd4f883f07c7644"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68c5a5fe8a38b73a3c3506594a28547b0837bc61e2db003fb714f8a55ba6c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11787cd07ccf85727fc6e94e56ddd145e7820aaaf9862854a0023c04b587d242"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4143abd1dfdb94b8070f2192dcdd8b2b727fd1bd1f8c7f5d6fb717ec26b30d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "15618a48af09636976ac937b8ed46f26ed18de79abb4a03b115f566fcfffff0b"
    sha256 cellar: :any_skip_relocation, ventura:        "984cec9d5c4f28c1567c9e4fb53f8307b5c1162600dbc2b971c6ca88903521a6"
    sha256 cellar: :any_skip_relocation, monterey:       "9944f4742741b29f49020517c2d3eae948c3541848d70c2d6c6915c50216e27f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d310a0366dbd51af6efc6fba5a35b350e3fe926e4f0400334d49ac5964c8b945"
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
