class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.4.tar.gz"
  sha256 "e74ec49c2402eb242fbfa16f2f43a19582a74c2eabfbfb873f00d4250038ceac"

  bottle do
    cellar :any
    sha256 "a8dedc44dfe77db4f76c8e722c80fdb2ad6b15be0e16686fbd7a31abf981935b" => :mojave
    sha256 "54b7c0319877b7545c22ef67effb91cca9e80c159b494b5e3f22067db062beb8" => :high_sierra
    sha256 "a68e9d9bf2d3192294bac33c5eca01d214faac4f17a6c3ce1bdcedda9a0e241f" => :sierra
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
