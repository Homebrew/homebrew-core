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
    sha256                               arm64_tahoe:   "2949d65a521165cb25962acc9d6e3090d6c07e2b64ab9406857a180646d8503c"
    sha256                               arm64_sequoia: "4469396d620f5628369b249c7c1061acf8c3440efc9ed983524ef5984d8af706"
    sha256                               arm64_sonoma:  "ef3a37a8ab7358f2ab0f9f57a8175e1a769d33c6828545f8ebf38e5dedb427b8"
    sha256                               arm64_ventura: "68483a37438ba702052fa92732b2728b9be185f2568a1e67a32a8a19f407f63f"
    sha256                               sonoma:        "c6fc59da6e3a82ea0b1ba17e8122d84b24ec9eab7fade3663925c557e40b6ac8"
    sha256                               ventura:       "92e95f7a48ffe21f00ca3df61e3bbe048e7687420f173c6e0e52b82f5aefe66b"
    sha256                               arm64_linux:   "7f81f123950068165ecf54cede5508aa8c5489001bac5c8676556b0acd027d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0538580f2f6c5deb7a0b6cc1225db0403eb24df11182224ed8ab584a743263f"
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
