class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2cc9f53d62c2c7d24983f1cc232d80c88e9b8388099a9217367f5756b37661b"
    sha256 cellar: :any,                 arm64_monterey: "9c3a09a6b01bf4f12ce8cf93a3a84a2fd69374f37efaaae1407f9b08d60909f6"
    sha256 cellar: :any,                 arm64_big_sur:  "df69bf9d42edb022106c78000302b411e6d74fdb9887fcf77a1faf9c9471bb07"
    sha256 cellar: :any,                 ventura:        "fa8891242afb08536f0a549968948b49f13d099a7f7bf5e9f558f9772a49654b"
    sha256 cellar: :any,                 monterey:       "d1a110b94053b04b196860c796306b65548a78095c7f7a1284207b6d7cff0014"
    sha256 cellar: :any,                 big_sur:        "0e945058276859291d1a893ffd5d8344e38b5386880d06428d9c4702f6d95b4d"
    sha256 cellar: :any,                 catalina:       "9c00923f573a9ef1602f0a4a8146732746ffb3d61c5516e0dacda51f9fa7dd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9932fbe1d2c977082001cf66d39b60deeaac1f734077ed20cfebc26d335b2c5a"
  end

  head do
    url "https://github.com/libsdl-org/SDL_net.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "sdl12-compat"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
