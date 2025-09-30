class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://github.com/boysetsfrog/vimpc/archive/refs/tags/v0.09.2.tar.gz"
  sha256 "caa772f984e35b1c2fbe0349bc9068fc00c17bcfcc0c596f818fa894cac035ce"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/boysetsfrog/vimpc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "8013c280a8da6f6acbe6df84589b721620b2ae2d171374a8a1775e80636d213a"
    sha256 arm64_sequoia: "1fcf1d047f24ee3ba7d4ef487535073559d3cd25129d607581784f2625e40bcf"
    sha256 arm64_sonoma:  "e1e7386a32a897ad76ea0a934d81f3c694f32638df2a7ec6a440703e00086f00"
    sha256 arm64_ventura: "c8ba4e9529a838e511d9a8cef03df1fff057074983c6ec28a8b89b5b948257d3"
    sha256 sonoma:        "f176d799036dee333704bb6fbc5c682703b384df24710d566353fbd36c5c73c1"
    sha256 ventura:       "5c2aaf2d541312c5cc94edee59489088f397a5345e548e869057b1c62eb32d65"
    sha256 arm64_linux:   "7228a6e08f338c414bd766a2616bc2b25dab0daad7d6c0c381c62724f634a1c9"
    sha256 x86_64_linux:  "20f51a883a9520406f7cbfd7e8c8d9bc533efbb03ce4ecd63e3578aca351daa4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libmpdclient"
  depends_on "pcre"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"vimpc", "-v"
  end
end
