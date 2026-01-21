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
    sha256                               arm64_tahoe:   "ca80d208eea658f17fd5da3d0bda8812cb1d6deff343dfec6512143fda9eb36d"
    sha256                               arm64_sequoia: "795dba32598da1f2df6d7e32f60f79aaf3b02a722ad79656243cd718b566c6e4"
    sha256                               arm64_sonoma:  "249e8ac4a156dcebf614c25758b070678274541b1c42e842fe170ab48c1b7ef3"
    sha256                               sonoma:        "309683b869b3afd78996e9b2f0b41a9d74e7ced5a09149e21719d4bbbeed8a01"
    sha256                               arm64_linux:   "cffc297c26ec11453ce2594f7ea9cce99bd6ccf3aff3eab15f13820a685857ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a165d435ccc9bc742b9322cea92a6dd704f8053b0bd772f1c644230ff07efb5"
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
