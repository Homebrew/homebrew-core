class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.5/synfig-1.5.5.tar.gz"
  sha256 "95783c92925bd8ae494e00fdab0340caba9b19d2a0aac989fd8c200434b26f06"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "b94df31073931940265aec604270cdacaf67226ec4f2581bbb51c41d2d713e2d"
    sha256               arm64_sequoia: "619a5975ff1e86cdcccfbf1adce7bc44c21ad5115a61ad455cd250b6c653464d"
    sha256               arm64_sonoma:  "abd9fa36b9a5829a15f2089cd773a6995dc6bc94329a2f00b52adc359a6c3211"
    sha256               sonoma:        "4b2887cf8b8bde5c5450806c8d9c52e9c2802012f9ae6a562e2c984df3eb7b3c"
    sha256               arm64_linux:   "6fc49a6615075506551c89209b8742aac115b5609e2a74fb503e687f1c441aec"
    sha256 cellar: :any, x86_64_linux:  "fd2e459cd5ffb4ed53364d87e5206712e5f6c3dea81f577e086db02e60948ce5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "etl"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "harfbuzz"
  depends_on "imagemagick"
  depends_on "imath"
  depends_on "libmng"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libtool"
  depends_on "libxml++"
  depends_on "libzip"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    # missing install-sh in the tarball, and re-generate configure script
    # upstream bug report, https://github.com/synfig/synfig/issues/3398
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules",
                          "--without-jpeg",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stddef.h>
      #include <synfig/version.h>
      int main(int argc, char *argv[])
      {
        const char *version = synfig::get_version();
        return 0;
      }
    CPP

    pkgconf_flags = shell_output("pkgconf --cflags --libs libavcodec synfig").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *pkgconf_flags
    system "./test"
  end
end
