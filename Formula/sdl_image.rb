class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 3

  bottle do
    cellar :any
    sha256 "838d4345676e4e05252aa3241a7d029359f42c1d4eb49e8d58ccd2b60518e648" => :sierra
    sha256 "a4638bcb9c0334bbf5b934e5f76f256da233b611d1a66c51311de5d593ea867e" => :el_capitan
    sha256 "df945572e0d8802860d258981206488002a64080de64c1f6085a766fdd113734" => :yosemite
    sha256 "cdcfe4b687320449ea64d1cc4724a5698420a13c1497cd0533fafb0ada0b0d80" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  # Fix graphical glitching
  # https://github.com/Homebrew/homebrew-python/issues/281
  # https://trac.macports.org/ticket/37453
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/41996822/sdl_image/IMG_ImageIO.m.patch"
    sha256 "c43c5defe63b6f459325798e41fe3fdf0a2d32a6f4a57e76a056e752372d7b09"
  end

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make", "install"
  end
end
