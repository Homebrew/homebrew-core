class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://gitlab.com/sane-project/frontend/xsane"
  license "GPL-2.0-or-later"
  revision 7

  stable do
    # TODO: Switch to `gtk+3` on next release
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
    mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
    sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"

    depends_on "gtk+"

    # Backport support for libpng 1.5+
    patch do
      url "https://gitlab.com/sane-project/frontend/xsane/-/commit/c2b5b530347af80cb192b30a4bd6039e7714a4fb.diff"
      sha256 "9a94caf7fee69e047eca8d947c4f275473a2fa6d1ee2f0fb116bc2efdd9ea7e8"
    end
  end

  livecheck do
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/"
    regex(/href=.*?xsane[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "941fa6509e6e252e468c894c6066dbd46c301b2c3046059e6c4f8215d391294f"
    sha256 arm64_sequoia: "0d66e34d8305f5d856e9f83e7b5aee1dfea383b0ac21071a064f1d15536f259a"
    sha256 arm64_sonoma:  "dbe17560abb0219f0b2a71c25b7dc6a439cc05e2adb96eb567d48bd05401ad36"
    sha256 sonoma:        "42c97c01bb304dbcc2ee1ee6648ca11f61aa373cab7ee3105e627b192f87a1f5"
    sha256 arm64_linux:   "2e6a96863d3108421a4f8907d76ef8e5d05399fe151af51a9864d04afe895493"
    sha256 x86_64_linux:  "a37202cd6cbc1a49669b25b6131c30c5c0e555ea8a4d06a2ebbe5ee71b8eded8"
  end

  head do
    url "https://gitlab.com/sane-project/frontend/xsane.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk+3"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sane-backends"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "zlib-ng-compat"
  end

  def install
    if build.head?
      # Work around https://gitlab.com/sane-project/frontend/xsane/-/issues/74
      inreplace "src/Makefile.am", "$(GIMP_LIBS)", "\\0 $(ZLIB_LIBS)"

      system "autoreconf", "--force", "--install", "--verbose"
    elsif version > "0.999"
      odie "Remove `-Wno-implicit-function-declaration` workaround"
    elsif DevelopmentTools.clang_build_version >= 1200
      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/xsane --version"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match version.to_s, shell_output(cmd)
  end
end
