class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"
  revision 3

  bottle do
    cellar :any
    sha256 "5d6a399de125a3de57dba84852063f08cba68cf07dc925c4ee671988f04f8a37" => :sierra
    sha256 "464d0a95b54e9a0221f8fb972dde4238ae94bf30289c12a239252a2fbcde006d" => :el_capitan
    sha256 "1411e639d93dab99c8e25c54f7e1262bfbb36df145f3664cf3af33c470336d65" => :yosemite
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
