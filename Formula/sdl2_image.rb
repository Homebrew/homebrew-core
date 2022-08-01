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
    sha256 cellar: :any,                 arm64_monterey: "bf747bd43cbd3cacc593b5ba80db92d163369e94ed7d026d6c5e6ea3026d961c"
    sha256 cellar: :any,                 arm64_big_sur:  "42d1afab7256736c0d8388226d392942f54c97532f23731a04341eca7241374b"
    sha256 cellar: :any,                 monterey:       "cf375ec6014ed15cad4e3e3f25fd9796781ba42662a1fc4272c7fa94c7b73242"
    sha256 cellar: :any,                 big_sur:        "04993039224965866d9c28ffe73bd477557e24b0462f30ae07b410306fd86a6b"
    sha256 cellar: :any,                 catalina:       "538e45e7c2e6ae8a4e00cc18802fa9f22f73504365e1b095c43783e0ffbfabcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a24ee1889e1ead85e6f9b3a46898875154c4a84c870c2e70eaabb5572cfbbe3c"
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
