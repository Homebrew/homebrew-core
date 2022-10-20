class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.11.1.tar.gz"
  sha256 "2a03281dceb36df2515c3307cf452d578ee0db1a0ea0b321cc42d36df4f6d70b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f71ee8d2cec6aded455037265f87718bbec59b95178bea766734e337160e106"
    sha256 cellar: :any,                 arm64_big_sur:  "1a44631303ac534435ee86dc4224ff0de1fd517fbbd70cd08f849c7c9d75e338"
    sha256 cellar: :any,                 monterey:       "8e050628e88cc06dfce2d4d0470bf654cb3abb012cfde7f4b2cf3ddae50ff8a9"
    sha256 cellar: :any,                 big_sur:        "9d3363b3b0996097f690e95f83ed04a7b63591ae1650c7987419638078a0e957"
    sha256 cellar: :any,                 catalina:       "6453c11bb5139c8b92bf01ffa010bd131a71d5e1c9dd794d415afa4728720960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7153f86d7a5cb8577a95e429be23c92731cca9ad44d4c113fe5bdae6d0a8d9e7"
  end

  depends_on "python@3.10" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
