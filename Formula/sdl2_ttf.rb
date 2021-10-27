class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz"
  sha256 "a9eceb1ad88c1f1545cd7bd28e7cbc0b2c14191d40238f531a15b01b1b22cd33"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_ttf[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c11a07808c87dae658b12066a20f6bb7dd9d257de8e1fc660ea221bfc604ad7e"
    sha256 cellar: :any,                 arm64_big_sur:  "e1eebedabe4c9625e852feeb68abdfac5c2f55767d70d81e708f74f84dc41e8c"
    sha256 cellar: :any,                 monterey:       "9a75a0e6284a343c5bb67977284974a581b04d61d0e8ca5e1f8660777d84717e"
    sha256 cellar: :any,                 big_sur:        "f69eb853fb10f18eb9791c024ec12bad7cc95e65322934dddc35de4eff3019b9"
    sha256 cellar: :any,                 catalina:       "413959be382ea92bd59af9a29e5909d40db69c571447e2f0dec821cbff612d80"
    sha256 cellar: :any,                 mojave:         "74582129be8cfea5e556efa95411f9fc2eebf111c7b4f9affc80a7e05fa19cd9"
    sha256 cellar: :any,                 high_sierra:    "1867ff73485eaa12fc00def01be8e388443ac6c226065218bb435558fdb8bb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a2593fece1b4310d25ec60cd053f627ff4da46a1a589311e7505cf87dd694b"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

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
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_ttf", "-o", "test"
    system "./test"
  end
end
