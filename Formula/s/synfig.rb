class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.4/synfig-1.5.4.tar.gz"
  sha256 "b8fb9d609e3aedebde7b0efa0c3de3b1fa5c4b61f5493b7f797b496a80f15fd0"
  license "GPL-3.0-or-later"
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "c4bfc5af3eacc379168007869d3bf2812783b6ac4ef7e40f615b13ae431fd9ee"
    sha256                               arm64_sequoia: "059fbfcb678e0ba38ce383e7895624da78965573d2beca918a15ef4023867bda"
    sha256                               arm64_sonoma:  "3780751b8c12cdd49dcb4bc0a42a7b79702f1268cf983e95e9ee9921891d7911"
    sha256                               sonoma:        "804d7f628b553b269fd4fe7582f83c66af8ff22875fd766bd959ac3e9fda7d93"
    sha256                               arm64_linux:   "db544e07b436f64df708bc6f19255dbd9d3e64634bda978bdcc274e363a8070d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2241a4a7e43fc44cdfc02703a960af582331b97272a7ebc5ac87aab48cae23"
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
  depends_on "libzip"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
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

    # Workaround to fix error: a template argument list is expected after
    # a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    # PR ref: https://github.com/synfig/synfig/pull/3559
    if DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw"
    end

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
