class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.4.tar.gz"
  sha256 "63e0e01addedc9df2f85b93a248f06e8a04affa014a835c2ea34bfe34e576262"

  bottle do
    cellar :any
    sha256 "9db41c0f2fd4897456594769a4a549b5261c3027dde8fc6da7160faf7db0a539" => :catalina
    sha256 "0854ac56a8c0e0b3b5f7fe380fb0bde03dfb2da984920bcbc61ba6e4738f9ca6" => :mojave
    sha256 "6563ae4bda51a996e537cfe88509da94402b52469e11b92211b5bca58800ab24" => :high_sierra
    sha256 "fba875841d99a80ba39af65733a0df33adf220d29fbd5e313dfcc695b61bc8e4" => :sierra
    sha256 "aaec64e6b0020e3a0b2faf6ca37e5bc4b27d7327125a58831b0cd34803935cc7" => :el_capitan
  end

  depends_on "sdl2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL2_imageFilter.h>

      int main()
      {
        int mmx = SDL_imageFilterMMXdetect();
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_gfx", "test.c", "-o", "test"
    system "./test"
  end
end
