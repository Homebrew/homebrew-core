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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "276ef6bd7689e92643c1d8b8e560e836b1714064650ca8f4b38c1ddf48d8dcbc"
    sha256 cellar: :any,                 arm64_big_sur:  "2b56b0aad77656b082496d57f253c364ccfd096e4e5bcd752b379d8b81afc987"
    sha256 cellar: :any,                 monterey:       "a40ec76bc109f3ecbb06a06f18305c68ad1f0b536e8f042cb690b3c11a60fc60"
    sha256 cellar: :any,                 big_sur:        "6e814132126b9864f22241a7940a66baaa249a580df19f67e83ecbaec31d50a2"
    sha256 cellar: :any,                 catalina:       "d8062b493aa5bd02daad17cebd94aea03dc1065f653fcbed1da40401a370ba79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eced143f47e50cdf8a2e064c990c21c005b102c032b45e7347714c80b5fb12a6"
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
