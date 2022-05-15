class QuartzWm < Formula
  desc "XQuartz window-manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/quartz-wm"
  url "https://gitlab.freedesktop.org/xorg/app/quartz-wm/-/archive/quartz-wm-1.3.2/quartz-wm-quartz-wm-1.3.2.tar.bz2"
  sha256 "dd185c7d7db9166c1e5ff2808bb5f6bc1b85321fafc1d3a3cf9968fb29c992ef"
  license "APSL-2.0"

  depends_on "autoconf"    => :build
  depends_on "automake"    => :build
  depends_on "libtool"     => :build
  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorg-server" => :test

  depends_on "libapplewm"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on :macos
  depends_on "pixman"

  def install
    # Fix build on Monterey
    # See https://trac.macports.org/ticket/63355
    if MacOS.version >= :monterey
      inreplace "src/quartz-wm.h", /(?=#undef Picture)/,
              "#include <ApplicationServices/ApplicationServices.h>\n"
    end

    configure_args = std_configure_args + %W[
      --with-bundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
      --enable-xplugin-dock-support
    ]

    system "autoreconf", "-i"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    fork do
      exec bin/"quartz-wm"
    end
  end
end
