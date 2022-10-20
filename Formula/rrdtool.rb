class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  license "GPL-2.0"

  stable do
    url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.8.0/rrdtool-1.8.0.tar.gz"
    sha256 "bd37614137d7a8dc523359648eb2a81631a34fd91a82ed5581916a52c08433f4"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_monterey: "86844a9bf1e4ef7777fb31f2fb99b093807d16c0fb998a9cf809c381aad45b71"
    sha256 arm64_big_sur:  "06f81e4c0eda98dee8c68d858b1fcc8bfa19c22d72f6aec9c31536b97f225da5"
    sha256 monterey:       "b78c7535a358b6c816ea45505ba8ff933c6b3304e682f33612f5c2a3461a44f2"
    sha256 big_sur:        "fb63e4b217d81a0394596c85858253cb2f38760e2ccc01c7db76a065c96f6034"
    sha256 catalina:       "e8881104bee0c2408b38adbe616b22cc128bb15c4154387156c20ee59316b759"
    sha256 x86_64_linux:   "4b669231e7a679f7ed9fcfb2da893ac38d0619b5b9526b66c32b14269bf53399"
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pango"

  uses_from_macos "groff"

  def install
    # fatal error: 'ruby/config.h' file not found
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-tcl
      --with-tcllib=/usr/lib
      --disable-perl-site-install
      --disable-ruby-site-install
    ]

    inreplace "configure", /^sleep 1$/, "#sleep 1"

    system "./bootstrap" if build.head?
    system "./configure", *args

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "install"
  end

  test do
    system "#{bin}/rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"
    system "#{bin}/rrdtool", "dump", "temperature.rrd"
  end
end
