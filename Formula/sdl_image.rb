class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://github.com/libsdl-org/SDL_image"
  license "Zlib"
  revision 9

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
    sha256 cellar: :any,                 arm64_ventura:  "0c0146385b4a6ead2eeab4bf268d258ed31bbd07d046d8bfa1948f9acc82d1c4"
    sha256 cellar: :any,                 arm64_monterey: "e435e9a87ff6ea6e8dc76c021774968c24b3d1b60aa8e92bf54b8371e0fced71"
    sha256 cellar: :any,                 arm64_big_sur:  "926ea3035acd9fdfbcc45d5ac5269236a31a5fb6b5a18228e7a1fdd3457de1c5"
    sha256 cellar: :any,                 ventura:        "edc88daff8a49529fc5aaa9c833028e0ffdd992e389a32c5148d7a0e8354ad93"
    sha256 cellar: :any,                 monterey:       "9660cb60f381f37d02cd54f32bb3e8577d2b29b9e8b3821dedfbff8248032693"
    sha256 cellar: :any,                 big_sur:        "fe45394e435ed0e7748f6eb4e73c5119ba56fa62703e176822fb045bdad5aafb"
    sha256 cellar: :any,                 catalina:       "1cb2ce543f06042d72bed4497331932379ab3997ac822abf8a8717fd306ee7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734a5ce62847d851a6f4583685b3197ac50992ee403a681410b968e54c8d0709"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

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
