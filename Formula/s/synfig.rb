class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.5/synfig-1.5.5.tar.gz"
  sha256 "95783c92925bd8ae494e00fdab0340caba9b19d2a0aac989fd8c200434b26f06"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_golden_gate: "4f7eac631217c34575acd433d7d03ad7b40e448248bdcc7192541b93d45c8026"
    sha256               arm64_tahoe:       "5992bba5e7d80a6719bd081582235f5cc1087fb4aaf06761fc0fc61739647167"
    sha256               arm64_sequoia:     "b5ede87aec82a28d9501621d300a87f5606d78b3c5f9970dd839faef8ee30455"
    sha256               arm64_linux:       "a5ed09f641df4f438704aae7cbb5e9376012dbc799ec092c58337e0ab48a0247"
    sha256 cellar: :any, x86_64_linux:      "359225f666694a59c449c9fcee50ee4dd886932b7341e5c87e44a628df36f47f"
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

  deny_network_access!

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
