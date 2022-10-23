class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.46.tar.gz"
  sha256 "4bc53e96b49405e4a8ca579465bc1129adc719a96840b71b3ae99ec88e4d8c29"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "20aabecad8ad15c62ef31f71e3a9ffe70164ecdfd34fcc2d0bf9031f7ebc6bc9"
    sha256 arm64_monterey: "62b83711d4fb986ce4216fb0f363afb141f85fa040cb30cbedd12edf0e054a4f"
    sha256 arm64_big_sur:  "3bd849c8af633cd43cd51ba1ab2dab4dc1458258096522bc6ed999b280c15382"
    sha256 monterey:       "24fda363caa29db839258191f120746962dd1bc733a955b36c2596757998be2d"
    sha256 big_sur:        "626e1bae064bac19505b0223a136be38e49e1eb0c758ef2f1945d627d39a28e6"
    sha256 catalina:       "e70efc49a4b5dab8031b72714acc9ec0cb14c08ea84f0230a6510069bd68e42a"
    sha256 x86_64_linux:   "d5bcb12857bf4730cdfaa1a04dd8cc6b54952fef83c1660a2795e7a10d87f560"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rlwrap", "--version"
  end
end
