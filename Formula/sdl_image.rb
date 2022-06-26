class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image/release-1.2.html"
  license "Zlib"
  revision 7

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
    sha256 cellar: :any,                 arm64_monterey: "e69657726447aeb89029fa4fd47a615f8a53506f6ff594a947ae6fbf3d77b925"
    sha256 cellar: :any,                 arm64_big_sur:  "9720413694ba49519d1d1c5213607dbdf177939ae0ee081c03ab2c1d478e2fe3"
    sha256 cellar: :any,                 monterey:       "9d4fa42d89970868e4dc7779a6960f31790f25905e157e8e944963e98f4a850a"
    sha256 cellar: :any,                 big_sur:        "67495888095b02d6716cc51f5a522f2a872c29de418f19210ecd586d23684b81"
    sha256 cellar: :any,                 catalina:       "af782fa2905042005df213106578123c7fd1d6d3111af8bd16e1ec63e273bb8d"
    sha256 cellar: :any,                 mojave:         "eb27003d54259c16f08795435e2afc34086598e7f1d1f1ae4c2fe5a70a6bf57d"
    sha256 cellar: :any,                 high_sierra:    "eeb44401862df80a1d1f77dde4164b265d82993458325e753285566b56477695"
    sha256 cellar: :any,                 sierra:         "d74d6e853e78b65a7e7f266be6733bdb5839f956bcb19061b68a46c16e080a94"
    sha256 cellar: :any,                 el_capitan:     "4304e6b83a7afa176a0462e8ba20485bc098731a16bd375261f9f449a8f8f7d3"
    sha256 cellar: :any,                 yosemite:       "3403edd53a6776bad8dc4390ef8204479f3af7c485e8a7a1f81f86f43b4a7b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d8a3d6067fce20c398a6cfbe5ba87136f9d5968569a613b8a29e3bc3eef4817"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "jpeg"
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
