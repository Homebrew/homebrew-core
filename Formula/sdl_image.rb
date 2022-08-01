class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://github.com/libsdl-org/SDL_image"
  license "Zlib"
  revision 8

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
    sha256 cellar: :any,                 arm64_monterey: "b5d527b57fe9b8bf75202d9151479c53cf95f6880b5b55dfc5551b06fd730959"
    sha256 cellar: :any,                 arm64_big_sur:  "069b2a802ced9f3ef86bb672dbdea9eb7ee8d4d4a3b20a3e94199e74d540f051"
    sha256 cellar: :any,                 monterey:       "59eebbfccda7ba1872090e7ee0890aa232091d458d26a37cfb2574caaa559c9b"
    sha256 cellar: :any,                 big_sur:        "f77908b33aa70b26bce713423c397e6447cd1b50b01deff330d961a8b150239c"
    sha256 cellar: :any,                 catalina:       "271768b08ae1095c1c6898d6521b3f3d877e008517c9ae4524270c2d7c878239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22749cfbcd2aca9869f0c0190a76bc1367f821fd1ab3d687bc820949c9027106"
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
  depends_on "sdl"
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
