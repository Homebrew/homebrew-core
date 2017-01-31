class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 6

  bottle do
    cellar :any
    sha256 "16d716a38408f6d50447a36c1a3822f6621ce042290278017ead0d2ea3333107" => :sierra
    sha256 "0d6abc80c331bfb6c371291e5733bc42931e0c8b9b2db5b18b5f3a55d94d8e43" => :el_capitan
    sha256 "77677c0f05c1f9b54e9b5d198252da9a56089f978fc5468b6e5ff002515fb0aa" => :yosemite
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

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-imageio
      --disable-sdltest
    ]

    args << "--disable-png-shared" if build.with? "libpng"
    args << "--disable-jpg-shared" if build.with? "jpeg"
    args << "--disable-tif-shared" if build.with? "libtiff"
    args << "--disable-webp-shared" if build.with? "webp"

    system "./configure", *args
    system "make", "install"
  end
end
