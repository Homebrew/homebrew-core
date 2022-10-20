class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.6.tar.gz"
  sha256 "48656498ac30c59b902e98dc5e411e97cbb96278a01946bdf0941d8da72b2ae1"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe2014e9e8554a794a76538e627b3f7ea2061ec80b8397cbf59a73eb122f0448"
    sha256 cellar: :any,                 arm64_big_sur:  "35d18dbe25c5f32c163aba74b1c3bd76bef2d1e56daa157b0ee69b9260d31b03"
    sha256 cellar: :any,                 monterey:       "b7d4687e1268f63e2db6c206e3c689f12e1551d33486e76d6bd2630a7a222e5a"
    sha256 cellar: :any,                 big_sur:        "bae2b12de112b4078b7c27b944685296259fffffa703375c8537fdcf7fcf095f"
    sha256 cellar: :any,                 catalina:       "809aff2f1b2f94e3806b873087141df575cce1a95178ff5789c936542f0ab521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27663baf2b3c2fb110f345fdf3e7d88293d44e92563d36364e29f8e342cf308d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make", "install"
  end

  service do
    run [opt_sbin/"uptimed", "-f", "-p", var/"run/uptimed.pid"]
    keep_alive false
    working_dir opt_prefix
  end

  test do
    system "#{sbin}/uptimed", "-t", "0"
    sleep 2
    output = shell_output("#{bin}/uprecords -s")
    assert_match(/->\s+\d+\s+\d+\w,\s+\d+:\d+:\d+\s+|.*/, output, "Uptime returned is invalid")
  end
end
