class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.4.tar.gz"
  mirror "https://sources.voidlinux.org/SDL2_gfx-1.0.4/SDL2_gfx-1.0.4.tar.gz"
  sha256 "63e0e01addedc9df2f85b93a248f06e8a04affa014a835c2ea34bfe34e576262"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_gfx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c294fad8fbad927f3041868451946dc56c35f1d90f9aeef625e803113e65d09"
    sha256 cellar: :any,                 arm64_monterey: "7c17dcf54036d30d7bbc8d76bfcd51b8c966cc1653c886a7b188a897a483da94"
    sha256 cellar: :any,                 arm64_big_sur:  "7c632415953aecce33ea6b66b0d0b75461db7987bf560802e408d308bcd9b653"
    sha256 cellar: :any,                 ventura:        "07ced752aa459a1242b44edb51e3ad95146ac3a0920a904ce85d00ff22389906"
    sha256 cellar: :any,                 monterey:       "befe6548ad09bcdb75ce8363af39231065da928283ed7628daf7a5776725462c"
    sha256 cellar: :any,                 big_sur:        "9466b3ad0c9a29ca01a8c804b529ad7c89bd42c4d8b79b37bc079419464cc9f2"
    sha256 cellar: :any,                 catalina:       "9db41c0f2fd4897456594769a4a549b5261c3027dde8fc6da7160faf7db0a539"
    sha256 cellar: :any,                 mojave:         "0854ac56a8c0e0b3b5f7fe380fb0bde03dfb2da984920bcbc61ba6e4738f9ca6"
    sha256 cellar: :any,                 high_sierra:    "6563ae4bda51a996e537cfe88509da94402b52469e11b92211b5bca58800ab24"
    sha256 cellar: :any,                 sierra:         "fba875841d99a80ba39af65733a0df33adf220d29fbd5e313dfcc695b61bc8e4"
    sha256 cellar: :any,                 el_capitan:     "aaec64e6b0020e3a0b2faf6ca37e5bc4b27d7327125a58831b0cd34803935cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a779702029d05cd1923b70eff455385362d0069fcf31e0e0c1211279893ae5a"
  end

  depends_on "sdl2"

  def install
    extra_args = []
    extra_args << "--disable-mmx" if Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          *extra_args
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
    system ENV.cc, "test.c", "-L#{lib}", "-lSDL2_gfx", "-o", "test"
    system "./test"
  end
end
