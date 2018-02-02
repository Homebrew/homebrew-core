class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.2.tar.gz"
  sha256 "72df075aef91fc4585098ea7e0b072d416ec7599aa10473719fbe51e9b8f6ce8"

  bottle do
    cellar :any
    sha256 "bf5ff1c94ebde257e9d397fcab3d2ba42e870c771ff948ca54c25146f7da2f07" => :high_sierra
    sha256 "a9cda2a4abd47e4084212fdbb90c601dce4a1e599c0dcaad95b0fe139a5dad1a" => :sierra
    sha256 "cbe47c5ce034bea17df0ed477b143e6695ac81dda3c03de71252373ff0b1703f" => :el_capitan
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

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_image.h>

      int main()
      {
          int success = IMG_Init(0);
          IMG_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_image", "test.c", "-o", "test"
    system "./test"
  end
end
