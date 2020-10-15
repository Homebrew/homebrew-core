class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz"
  sha256 "a9eceb1ad88c1f1545cd7bd28e7cbc0b2c14191d40238f531a15b01b1b22cd33"
  head "https://hg.libsdl.org/SDL_ttf", using: :hg

  livecheck do
    url :homepage
    regex(/SDL2_ttf[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "413959be382ea92bd59af9a29e5909d40db69c571447e2f0dec821cbff612d80" => :catalina
    sha256 "74582129be8cfea5e556efa95411f9fc2eebf111c7b4f9affc80a7e05fa19cd9" => :mojave
    sha256 "1867ff73485eaa12fc00def01be8e388443ac6c226065218bb435558fdb8bb22" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_ttf", "test.c", "-o", "test"
    system "./test"
  end
end
