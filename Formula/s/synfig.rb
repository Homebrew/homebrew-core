class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://downloads.sourceforge.net/project/synfig/development/1.5.2/source/synfig-1.5.2.tar.gz"
  mirror "https://github.com/synfig/synfig/releases/download/v1.5.2/synfig-1.5.2.tar.gz"
  sha256 "0a7cff341eb0bcd31725996ad70c1461ce5ddb3c3ee9f899abeb4a3e77ab420e"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/synfig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:  "cf897c7b4ca90d3b11d4280d4c9f87792e47c331de1a8ae8f2dc8b7e77364a6f"
    sha256 arm64_ventura: "8a4aa8b68252349f620914abe3d341c5a096fd76a8987a3187ee7b014e45b54e"
    sha256 sonoma:        "5a683d57ebd562483d473d9355e502a01e06d62e97b17de7c7cee471a0347fdb"
    sha256 ventura:       "16e823e3f072aaaf8889377bf704702445677555e2850080d1f5a2a21af18fc3"
    sha256 x86_64_linux:  "7333419b778418bcbd3300a5f6d72bc69e8eaf429addb58dd450d34355b1df6d"
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
