class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "http://www.lrde.epita.fr/dload/spot/spot-2.11.5.tar.gz"
  sha256 "3acfd5cd112d00576ac234baeb34e1c6adf8c03155d4cda973e6317ac8bd1774"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5a4740e9874eca165e0c43d437e0080a2c299ab52a8f3f338bccf6ba1910607b"
    sha256 cellar: :any,                 arm64_monterey: "73c7ddb42ccc2b9f3816cea8b401be6d8ac0b226a20471b5120c397dffa502a4"
    sha256 cellar: :any,                 arm64_big_sur:  "364655234b5d2adec08643580e880cd63a23cd6571a7c9d205990fc2804f8a77"
    sha256 cellar: :any,                 ventura:        "e2f4084728b28346d3e15632d5424baeddcd525afcb9220c50cf8c3e0272f8a2"
    sha256 cellar: :any,                 monterey:       "c13895ef2cfb8ea3345cb8220411b06f22681ce92ff0bdd1d2131e4bef30c40a"
    sha256 cellar: :any,                 big_sur:        "a930816a6fe4436f6b9d614cd63aec037c281678d9701299412842d3ae888fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e474ed22478d2a138557a25a1a813e9d9f99c9220b4c929c347db4ab6c3684f1"
  end

  depends_on "python@3.11" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
