class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "eeac53ec10a125bda8268182ef0c557e58f0e970258ee732d77df63632937674" => :sierra
    sha256 "cc923332b0b59576b96a2cb6e8523172825ce054afc5b54bedb16a2528168105" => :el_capitan
    sha256 "294e3074de3c9f2d9eaeb7e113b5ffb02b9a001b10d42c8b3f15087d4f243ac2" => :yosemite
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
