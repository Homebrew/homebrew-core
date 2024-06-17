class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://github.com/libsdl-org/SDL_image"
  license "Zlib"
  revision 10

  stable do
    url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
    sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"

    # Fix graphical glitching
    # https://github.com/Homebrew/homebrew-python/issues/281
    # https://trac.macports.org/ticket/37453
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/41996822/sdl_image/IMG_ImageIO.m.patch"
      sha256 "c43c5defe63b6f459325798e41fe3fdf0a2d32a6f4a57e76a056e752372d7b09"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2309798338f6446f68fb9fea59df32fb2c49d4a231aa4142359a8b257910adb1"
    sha256 cellar: :any,                 arm64_ventura:  "f78f67df35a9a855ad454eb949ae9c29cbf8e46d8194d14200fdb4cbfdbc654e"
    sha256 cellar: :any,                 arm64_monterey: "d62d62d599148f2192757454c619fd4da0c348ce2569b86724fc5a6690bc3875"
    sha256 cellar: :any,                 arm64_big_sur:  "581f370aa1bc5aacca8e449936510213ece0d0aa6239609cfd2348f9b7117c82"
    sha256 cellar: :any,                 sonoma:         "8b6cce734fce986f63c6935b4b55f322c0352733682646bcf728af252b39df3e"
    sha256 cellar: :any,                 ventura:        "4a428361fb16f0234036e6d34dcdebd12c60a44c4ef298ade17e962ffaaf331b"
    sha256 cellar: :any,                 monterey:       "dbc80abd8e87a602aaa4c2b5fca7cb6819dcc05d667313cc5ef63cf762439923"
    sha256 cellar: :any,                 big_sur:        "1d5d05a09f10fe88be79a45a4ad4e062949be49f98ab54b30674df945258c079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018680e1d50e7dd54d71bdb8a8eb9978b8cbff05201a64d53724472c15f24b6c"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  disable! date: "2024-02-07", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl12-compat"
  depends_on "webp"

  def install
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-sdltest",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end
end
