class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "http://www.rsyslog.com"
  url "http://www.rsyslog.com/files/download/rsyslog/rsyslog-8.26.0.tar.gz"
  sha256 "637d43c4384f8b96dda873a0b8384045f72cb43139808dadd9e0a94dccf25916"

  bottle do
    sha256 "edf1c58262540bc3d4409d6a74a5784114ce31e9481064c6a147d299d61fa0b3" => :sierra
    sha256 "fe4b4b7732000b54f6bcc09495920fa27d2f09f31b575d424b9f71b73e32ae6e" => :el_capitan
    sha256 "a3434bafdb1c54eb0ea50fcbabbbf87f241dac07dd68be55c4de344db3daa114" => :yosemite
    sha256 "2f41f4e354de6cb6cd95630ed396a2099753adef10a63e0304fba550097f6237" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "docutils" => :build

  depends_on "libestr"
  depends_on "json-c"

  patch do
    url "https://github.com/rsyslog/rsyslog/commit/361c32579dbbbe576a5cbace0ac1b61d5d76ccd5.diff"
    sha256 "e1d39be0c8a504d51a81e2794a8f4795811ff13c67ce8f8d184acda055f6fd11"
  end

  resource "libfastjson" do
    url "https://github.com/rsyslog/libfastjson/archive/v0.99.4.tar.gz"
    sha256 "03ef63dcc88417e71c19ce4436804159e3397e3a20d3529efef6a43c3bef5c8d"
  end

  resource "liblogging" do
    url "https://github.com/rsyslog/liblogging/archive/v1.0.6.tar.gz"
    sha256 "5d235b7da35329d7d13349a4b941a197506a3c47bf8c27758c5e56b51c142c58"
  end

  def install
    resource("libfastjson").stage do
      system "./autogen.sh"
      system "./configure", "--prefix=#{buildpath}/libfastjson"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/libfastjson/lib/pkgconfig"

    resource("liblogging").stage do
      system "./autogen.sh"
      system "./configure", "--prefix=#{buildpath}/liblogging"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/liblogging/lib/pkgconfig"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-imfile
      --enable-usertools
      --enable-diagtools
      --enable-cached-man-pages
      --disable-uuid
      --disable-libgcrypt
      ac_cv_lib_pthread_pthread_setname_np=no
    ]
    
    inreplace "plugins/mmexternal/mmexternal.c",
               "defined(__FreeBSD__)",
               "defined(__FreeBSD__) || defined(__APPLE__)"

    inreplace "tools/Makefile.am", /-Wl,--whole-archive,.*/, ""
    inreplace "tools/Makefile.am", "-export-dynamic \\", "-export-dynamic"
    inreplace "tools/Makefile.am", "rscryutil_LDFLAGS = \\", "rscryutil_LDFLAGS = "

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
