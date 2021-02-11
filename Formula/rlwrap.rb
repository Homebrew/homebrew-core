class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.45.tar.gz"
  sha256 "780faa7330f306430aaf895984c936f451a8d35555145eff5451dc57b0c3ba8c"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "a28df3b1be0fc19dad13cf331050d506f523c1d0b6a9d640f43539579897e789"
    sha256 big_sur:       "8abc19f0485a74b99eaa365cc31928d3542162f3496738d9b263d86ec0424f16"
    sha256 catalina:      "52fbaa3a697ba20bfab89f15025834ed5f3345c0584fe10aab466a65cd6b2aae"
    sha256 mojave:        "98a7899c374b6525e8a2d8e4a2f4f7a2fd0adc1e18a1f306fa5d4dd195fa151b"
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
