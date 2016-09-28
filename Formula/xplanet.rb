class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "http://xplanet.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"

  bottle do
    sha256 "636ab38398e793471e33477e3940c8151866ea57443e0a2bd2f820890066f2b0" => :sierra
    sha256 "ecf69cdfcddd72c2237eb141a045abf062e1d25e89b58732a86c09e868ab66f3" => :el_capitan
    sha256 "eb4c003f5a3d278afd4dc2498a4e667a0aed4a97df07288c9246ca42002b1b76" => :yosemite
    sha256 "7cb1c47183147d061ab589073be7ff1b8be4cf78f96b240f27d164cddcb16858" => :mavericks
  end

  option "with-x11", "Build for X11 instead of Aqua"
  option "with-all", "Build with default Xplanet configuration dependencies"
  option "with-pango", "Build Xplanet to support Internationalized text library"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"

  depends_on "pkg-config" => :build

  depends_on "giflib" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  if build.with?("all")
    depends_on "netpbm"
    depends_on "pango"
    depends_on "cspice"
  end

  depends_on "netpbm" => :optional
  depends_on "pango" => :optional
  depends_on "cspice" => :optional

  depends_on "freetype"
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-cygwin
    ]

    if build.without?("all")
      args << "--without-gif" if build.without?("giflib")
      args << "--without-jpeg" if build.without?("jpeg")
      args << "--without-libpng" if build.without?("libpng")
      args << "--without-libtiff" if build.without?("libtiff")
      args << "--without-pnm" if build.without?("netpbm")
      args << "--without-pango" if build.without?("pango")
      args << "--without-cspice" if build.without?("cspice")
    end

    if build.with?("x11")
      args << "--with-x" << "--with-xscreensaver" << "--without-aqua"
    else
      args << "--with-aqua" << "--without-x" << "--without-xscreensaver"
    end

    if build.with?("netpbm") || build.with?("all")
      netpbm = Formula["netpbm"].opt_prefix
      ENV.append "CPPFLAGS", "-I#{netpbm}/include/netpbm"
      ENV.append "LDFLAGS", "-L#{netpbm}/lib"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xplanet", "-geometry", "4096x2160", "-projection", "mercator", "-gmtlabel", "-num_times", "1", "-output", "#{testpath}/xp-test.png"
  end
end
