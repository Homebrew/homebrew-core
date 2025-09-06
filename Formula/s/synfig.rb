class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.3/synfig-1.5.3.tar.gz"
  sha256 "913c9cee6e5ad8fd6db3b3607c5b5ae0312f9ee6720c60619e3a97da98501ea8"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sonoma:  "3c3a98577381b53308561bed6a7b384fe937e07a90370920e99ec8961baa7ee4"
    sha256                               arm64_ventura: "417d5f08a21f086cac5f783e38c25c0892dd926e6c68b56be06480a58cc3e918"
    sha256                               sonoma:        "2e3ba3584439484f6b26d6f83c4479862eabc64a72b8a1fc4ac69bd819055af4"
    sha256                               ventura:       "5aecf1d776296f38eaeb436669755a56bc2e2e87ad7cb16bb3bf688393a7e171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf67766653f8f6273dbf9b5285dbbbd16aeb1d11032505d11ef142b178cc42fb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
  depends_on "gettext"
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
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
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
