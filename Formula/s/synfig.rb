class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.5/synfig-1.5.5.tar.gz"
  sha256 "95783c92925bd8ae494e00fdab0340caba9b19d2a0aac989fd8c200434b26f06"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "a85aa434ebf61a1f7cf508399c5b8b2247e5ae3ed672ad5d1896111ee6ac402b"
    sha256               arm64_sequoia: "86f62a41b3d93174dd956cd933ce3c162d028500f2544266717cf73967ee6502"
    sha256               arm64_sonoma:  "b176f24bb3f5e523b2263e092dd1bf0094f5f6b1486ae0b2c30dbd4d62644866"
    sha256               sonoma:        "516171188bfdaa3ccc0455ddb2b226178bfabd367fb81806066a9ed470f45e5b"
    sha256               arm64_linux:   "15c924adfce53ff29e17f3f9c7e0b2c1033f66d6c8c6a899bcb0d8e2902389df"
    sha256 cellar: :any, x86_64_linux:  "314c4f229a4996cc90fb1f5a0058bd7de13f7615c82f6d0f32874b2c20d4f28f"
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
