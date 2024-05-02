class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.1.tar.bz2"
  sha256 "b1b44e9334df137bea5a73d9a84ebe71072bf622c63020a2a7a5536ecff1cd91"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "126f783ead8a4f42f676c008933c2e3fb5983b372e96d7188ba6496e8a380328"
    sha256 arm64_ventura:  "a44f31c5079670c8bc02ac8743260e1155a8705d23b49bbc0bf6053f2cd8cb8c"
    sha256 arm64_monterey: "debd845f98785104d2996147e1f79b101f46e13abdc51506c52a827548592879"
    sha256 sonoma:         "1ea8b9824a23a709b803f03a1a3c8e166fb378e8c6820f15b51118f52092f56f"
    sha256 ventura:        "dc38d9c2e72e5f7f3f4c0db57d244a2da215fb558008865a918e478471bd8c32"
    sha256 monterey:       "7648074a8640f8e62d4379b572d280ff4edc3cc2d3d34614898968784263fac7"
    sha256 x86_64_linux:   "55ef929b7c4276374b6567b3d8c586cc21a900c3e93c1ea55147b8feb2846294"
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg@6"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "wcslib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    args = %w[
      --force-fallback-for=kplot
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end
