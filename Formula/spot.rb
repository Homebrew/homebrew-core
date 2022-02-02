class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.10.4.tar.gz"
  sha256 "e8629cdb6cce83077826960cd01ece5213daaf9a283d6f62aaf69afa0623478a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "68bf87b6061e1ca497ff20a5c465fb587a14d240131383b18ecc2935f054f2ea"
    sha256 cellar: :any,                 arm64_big_sur:  "d74469da724e5e5c4f6e6fb352b7ebe6a655ed89d564513e6592f1d4c601815d"
    sha256 cellar: :any,                 monterey:       "3b8b8fb05bb561021e036e20db485310f0e30eb489653c11a4b07d1dbd5b2c0b"
    sha256 cellar: :any,                 big_sur:        "bb673787ddc9583b9d6ee547beaeb32d803646e87ee3db744f6283d07cafbc59"
    sha256 cellar: :any,                 catalina:       "4ce9d5981659d531e3a630e519bc8284815aa1eb80c8bb081945d557dd7bca63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644a4629a97e723c97a1f312c921ecb4ac9e8dfc67f742dfb70ed5d9d287e4ba"
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
