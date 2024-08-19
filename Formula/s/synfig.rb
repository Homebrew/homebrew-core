class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://synfig.org/"
  url "https://downloads.sourceforge.net/project/synfig/development/1.5.2/synfig-1.5.2.tar.gz"
  mirror "https://github.com/synfig/synfig/releases/download/v1.5.2/synfig-1.5.2.tar.gz"
  sha256 "0a7cff341eb0bcd31725996ad70c1461ce5ddb3c3ee9f899abeb4a3e77ab420e"
  license "GPL-3.0-or-later"
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/synfig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "1f56eb46a5bf1422a2c3345fb49e4a812ef751dba399404935ea00da9aeb38c1"
    sha256 arm64_ventura:  "26e27b1c7dc24f2bb74a8bcbbcc77e9ab29dff4b38f239f0cf9ae43eaacdb07b"
    sha256 arm64_monterey: "4376deb8c41e5451988b56058f11e8ea5445fffc6edc2a5316c4be26e8f977ab"
    sha256 sonoma:         "9c5c64089bd7aa8c221a8a12f3de8efaf2676f4a99bfd42db85c2f5e617073fe"
    sha256 ventura:        "4e60da11ecfbe746754edb822a48e180b8edac7a2f152f4558aa13d051eb6e6c"
    sha256 monterey:       "9e9740207cabd7c388632446d21b24779b77fb421a6713843cb1f8705ab74f14"
    sha256 x86_64_linux:   "b303fb306eb771db2efb5dbf9e1608f7fd7f7904947f9ea64698e9977c1732ac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "cairo"
  depends_on "etl"
  depends_on "ffmpeg@6"
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
