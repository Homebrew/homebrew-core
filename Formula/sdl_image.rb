class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 4

  bottle do
    cellar :any
    sha256 "c33b83a550f59dda30e1a89e4b641e1fcb5b51042f991b41aaa64d4790ac1add" => :sierra
    sha256 "7f88784dcac2131166af9721b33abf0130eb9e51538f0ad2f4e575830279a6c8" => :el_capitan
    sha256 "4c06ae51142919fbf22ff7208801592b8a9195ba214b83bd79eae2491ed72855" => :yosemite
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
                          "--disable-imageio",
                          "--disable-sdltest"
    system "make", "install"
  end
end
