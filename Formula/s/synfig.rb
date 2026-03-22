class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://github.com/synfig/synfig/releases/download/v1.5.5/synfig-1.5.5.tar.gz"
  sha256 "95783c92925bd8ae494e00fdab0340caba9b19d2a0aac989fd8c200434b26f06"
  license "GPL-3.0-or-later"
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "0075ee7f2b25f9de48de93254a812e88fa322d69aa957f7ea5b6e476568a2fe2"
    sha256                               arm64_sequoia: "5152754bac39e931dc349b505fcf372efb685c2cce060f4b55f699209ad1461a"
    sha256                               arm64_sonoma:  "a42fa1cdaf0f9e9747cdc428856f7aae6a2d956ff2a02aa0b9813c0629711931"
    sha256                               sonoma:        "5de592eda1f7ea792af3d7e997a57389caa25a865c68f0153c2a38287f8b12d4"
    sha256                               arm64_linux:   "32554a263478194272fddda52532ee6a7cb8092cc470776c65cef8249bb72c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2ec08203b96158a0a24897ce37ff1a2f40d94ae01691df1f8df89f88f7cc33"
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
