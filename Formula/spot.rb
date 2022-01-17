class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.10.3.tar.gz"
  sha256 "897e95486173748f2b65eecbd99a234b7f6877f2186e868da7ace5671804019f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5466087357a3cd15f862ee0548383657dcda00439bc74d7b2401779c2307e271"
    sha256 cellar: :any,                 arm64_big_sur:  "7ac2ac95c502e721cfface5e2514875cb0029b28d7e253bc8832de3f1dabe126"
    sha256 cellar: :any,                 monterey:       "74a0288b1ce8613d57bad11f5787bb67c10ac4710714e5965e9004cda2b5b685"
    sha256 cellar: :any,                 big_sur:        "cec705086835f3d0de204d7ad3c6a42195197a936bc58b451128b73dee94316e"
    sha256 cellar: :any,                 catalina:       "379351b53d1d4309e6f3af4e97355f570c7a7f6655540ecbad0e623ccd349091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04b51c8e9bea74d0371749f7ea50d1d16ac806536f548b0ce1b26eb44e7cea4"
  end

  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
