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
    sha256 arm64_sonoma:   "9a207a4d04477200a97b293a121ee23bef93b79fa7d35753d2434cd2ba3f8755"
    sha256 arm64_ventura:  "b7783b968173a20f5cb238d5d6b96aec8bab90c028b06e4d0e83175260aad337"
    sha256 arm64_monterey: "d12edc24c209c6c1b69b4c33bea61f69928e8b754ed9bfe8e135d33ab598f475"
    sha256 sonoma:         "bb0a61eb27adc040065977fd59f493b4d6f17f8ca36424a5093f957b1819c953"
    sha256 ventura:        "5cab6f62912a985f4f5d3032e5dea7835c9b369b02b8d5d2a0283c3168d7dd98"
    sha256 monterey:       "dcda0015cf9409f91c8796c04daf6dc012ac29672a36b4c5e9afa5073d68d431"
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
  depends_on "freetype"
  depends_on "gettext"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libtool"
  depends_on "libxml++"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "fontconfig"
    depends_on "fribidi"
    depends_on "glib"
    depends_on "glibmm@2.66"
    depends_on "harfbuzz"
    depends_on "imath"
    depends_on "liblqr"
    depends_on "libmng"
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
                          "--with-boost=#{Formula["boost"].opt_prefix}",
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

    pkg_config_flags = shell_output("pkg-config --cflags --libs libavcodec synfig").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
