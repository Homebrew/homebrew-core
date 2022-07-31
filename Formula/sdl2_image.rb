class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.0/SDL2_image-2.6.0.tar.gz"
  sha256 "611c862f40de3b883393aabaa8d6df350aa3ae4814d65030972e402edae85aaa"
  license "Zlib"
  revision 1

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4fee7d1294af38943891f173ed8d85e489376bb6cca38b09df6db0d7551fbdae"
    sha256 cellar: :any,                 arm64_big_sur:  "b6bb839868d441e6d8fabc08efd86d3ffdf554c48279380fcfa83dd2297aef90"
    sha256 cellar: :any,                 monterey:       "62806004dbe03f3a95d36eacfc751b09c11db0d01678645b15dadb916441051c"
    sha256 cellar: :any,                 big_sur:        "349c266ef7b099824f3666a40cd9231b8831e7d889bd566221f1e6ab1bf62db0"
    sha256 cellar: :any,                 catalina:       "d4038db5c17229d4ddfdf9567b4523dda82ee505c0a83dfc5ddaf7b242d228dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a7b8122f1cfcc8cab265e80baa84093cf7c573004df8d98ed25cb5a5abace3"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args,
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-stb-image",
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
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
