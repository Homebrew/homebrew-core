class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"
  revision 2

  bottle do
    cellar :any
    sha256 "947ed2dbcc3bd8c6b4188dbc2874d8b06e95aee64d58eb530b6f5215f4574cf6" => :sierra
    sha256 "da313993c1cc825c342ef0d8e1a7fefaeec399654eb56b0b07f33b767555c4ba" => :el_capitan
    sha256 "f5aaf7b8c035d662c696fa818ac4d82f33108ae1874f88e471368b29938ae20f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end
end
