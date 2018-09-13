class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.3.tar.gz"
  sha256 "3510c25da735ffcd8ce3b65073150ff4f7f9493b866e85b83738083b556d2368"

  bottle do
    cellar :any
    sha256 "4043fef6622dbe98c1eba0fe8936c718498bd608d351283931f4349c4009d86e" => :mojave
    sha256 "5e85d55eb46958bfba548130aebcccfab0a98f048063b0074980940851fa59a1" => :high_sierra
    sha256 "feeb2704291485affd5d3c4dee9842d4fdc006b2c0d8a49ab8010f2393dd2580" => :sierra
    sha256 "9172af9ae56b649b51f987a2ebee06f0c58ca070d63556fd65260ffbb1f11b76" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

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
