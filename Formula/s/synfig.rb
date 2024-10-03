class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.3/synfig-1.5.3.tar.gz"
  sha256 "913c9cee6e5ad8fd6db3b3607c5b5ae0312f9ee6720c60619e3a97da98501ea8"
  license "GPL-3.0-or-later"
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_sonoma:   "215e214b9ebb1e44193cc9c9b72d79dc6f9a35a33f4bab89893c1943a553a38a"
    sha256 arm64_ventura:  "005402c971bd3fff896a2b5953029bc47c74d9ad47c244b8876d37c0008b8acd"
    sha256 arm64_monterey: "87580f412466c2cc5f6e871de5ae2f331831abc02d204dda705f00ca8c87e216"
    sha256 sonoma:         "91327f9de2c7cfaa6d805338e5b7c9a4bc4f3c6e6166ee815de090f38e4b6c74"
    sha256 ventura:        "d0eecbd0a7629c95a7e2d2b447ed88388772cb81a822cc0fb31e129fa17f108c"
    sha256 monterey:       "a136f2dd2ce9ca0860ebbf517831b4ead42250a92e4fc2aeee0c88186f301d4e"
    sha256 x86_64_linux:   "8756ad19dc3c0f2b49a0b07a8e07d4766df49f3aa6cdcc6ae1c95cadab4306b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]

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

  fails_with gcc: "5"

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

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
    (testpath/"test.cpp").write <<~EOS
      #include <stddef.h>
      #include <synfig/version.h>
      int main(int argc, char *argv[])
      {
        const char *version = synfig::get_version();
        return 0;
      }
    EOS

    ENV.append_path "PKG_CONFIG_PATH", Formula["ffmpeg@6"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libavcodec synfig").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
