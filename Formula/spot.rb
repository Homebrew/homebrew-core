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
    sha256 cellar: :any,                 arm64_monterey: "31f33501ec68a60e443c48a01e24d27957c8eede7483cf6ae582a0052ea2fcf7"
    sha256 cellar: :any,                 arm64_big_sur:  "3bfe65a7a78ea709b5f36420332c4d0857ab87fc0b52cd599cfe74197a336b02"
    sha256 cellar: :any,                 monterey:       "45c706b5a3b800059aa66c677b5664e12af3044c27c5e68316aada66565e0fa5"
    sha256 cellar: :any,                 big_sur:        "3028e50d36584f7e40f6e57c6df5eaf971b6b5524730301648e13bad1d6329ad"
    sha256 cellar: :any,                 catalina:       "7331f205366f3221821cdebd625722ebe7f73d0778da36783aec74cac1d79262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8b6ccbaf08883bfb91405b541b525f96673395ff6724e4f4d2aea628e98763"
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
