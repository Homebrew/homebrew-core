class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lrde.epita.fr/"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.10.6.tar.gz"
  sha256 "c588d1cb53ccea3e592f99402b14c2f4367b349ecef8e17b6d391df146bc8ba4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://spot.lrde.epita.fr/install.html"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b1430858b8bb86bf381ce7ce6bdf2ad6353eca969ff76967e5f307ad9e21032c"
    sha256 cellar: :any,                 arm64_big_sur:  "3446679a5ef8e565deff8aa7cb25b3da156056cd0e96f084e64a920cef428fce"
    sha256 cellar: :any,                 monterey:       "bedb932f538883e9fad2d64dc00b5185ecc49d44ef99b88ab65d6d0951c76827"
    sha256 cellar: :any,                 big_sur:        "62b1883615299ed12f9bda54f0b381ce5ffcc4badbc0ba0d8a59301f97d5e60d"
    sha256 cellar: :any,                 catalina:       "06eefd56dca1c57ddaa883ec4f0985db4b48ee119befa0e18ef7fe67221040e9"
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
