class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  license "GPL-2.0"
  revision 1

  stable do
    url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.7.2/rrdtool-1.7.2.tar.gz"
    sha256 "a199faeb7eff7cafc46fac253e682d833d08932f3db93a550a4a5af180ca58db"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_monterey: "f5e9023421edd68399a3b06dfe4cc1d0865177442a7e57c9a17b1725f31dc7f2"
    sha256 arm64_big_sur:  "ad12dac7aa98a147308996e0428a0a1c7cd00ad61a79b4256fc4b328037f11a8"
    sha256 monterey:       "f22735ff395512edcf8c44dd42f7facbdcdb7f720c707c1fb94442512c9616ad"
    sha256 big_sur:        "9d4f04228051780a37f8351c79773e3ed7492d5989b75e403e307d819163f35a"
    sha256 catalina:       "ce57cda576f452e7790e091d645887231d4aa5b691e2c33b4ea93b3dd92d7757"
    sha256 mojave:         "fae6691230b527c93670d1d00b266e43497744fc09df06c9977265e578b529fc"
    sha256 high_sierra:    "858013744cfc3d31a47b7e3629198922d1994f20d0d44c11f6c921ce6f2b9942"
    sha256 x86_64_linux:   "f05f4ccf30058ab7f637b428ad155e318b8a03c7b8c64b8a8d22e6cfdad3a32f"
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
