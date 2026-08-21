class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.5/synfig-1.5.5.tar.gz"
  sha256 "95783c92925bd8ae494e00fdab0340caba9b19d2a0aac989fd8c200434b26f06"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "56262007c9628dcd690ae70aa289dc4b8477dfc01619cb793d6b3eb956f83c38"
    sha256               arm64_sequoia: "fe1fd898b8234fb8584ac6eaf3372e34b276d411e1313623ebb0d50052039f43"
    sha256               arm64_sonoma:  "570dad6af3a79433cc0fe59b06ce98a0ba6183b2472749cafad6c657b1fc8689"
    sha256               sonoma:        "4c7bed5a5e0be48560355477f2f710fab0b0a3d9fdf6499b562b8311524c4a78"
    sha256               arm64_linux:   "d2789b688ed8a45e45623113b8aa9d17644873c5b6c9b65d16663b7df3018c09"
    sha256 cellar: :any, x86_64_linux:  "92da725ae700b13a6282c7d757dc1d6ce45f5c1ec7c6be0e6bc4760252dfc39b"
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
