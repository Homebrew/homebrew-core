class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.20.1/SDL2_ttf-2.20.1.tar.gz"
  sha256 "78cdad51f3cc3ada6932b1bb6e914b33798ab970a1e817763f22ddbfd97d0c57"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f5a9b8a1070a7cdc45c2dd022a913e25e61615325b17a27bf8e875d558fb39f2"
    sha256 cellar: :any,                 arm64_big_sur:  "cd5e1a3e68f69196cd6e2f098c59b8f007b0fbc6996278f143d694d3728b5e18"
    sha256 cellar: :any,                 monterey:       "42b3b4ade6f0a1381e2eac3940075958a457a7c8bc48bddfa6ca899b46930941"
    sha256 cellar: :any,                 big_sur:        "f0e4d18625ca3f0b3946fa32673997835fa3a806f2b009246585ab6e24f8f6cb"
    sha256 cellar: :any,                 catalina:       "64c242b382fade26fd5aa9dcfff1ed6bf9e77ec1b7ee067cc5f732928ef0ffbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b67ffbe992ea85192068e242985bda62e50fc496fbf1c38903222456a1006c"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    # `--enable-harfbuzz` is the default, but we pass it
    # explicitly to generate an error when it isn't found.
    system "./configure", "--disable-freetype-builtin",
                          "--disable-harfbuzz-builtin",
                          "--enable-harfbuzz",
                          *std_configure_args
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
