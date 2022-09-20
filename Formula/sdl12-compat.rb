class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.56.tar.gz"
  sha256 "f62f3e15f95aade366ee6c03f291e8825c4689390a6be681535259a877259c58"
  license all_of: ["Zlib", "MIT-0"]
  revision 1
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "28a52174028532660d3526dc2057674b58379230c7bf1f7e325d7450c4be5f4a"
    sha256 cellar: :any,                 arm64_big_sur:  "cc9f77abf218e5b16d3f4fa970c2be4fc46da61e8a37b79a78907a570ec4517a"
    sha256 cellar: :any,                 monterey:       "e145a7fa135f4c2832d7f7416545f5942dcba7e3bad494a658d159503e5305c6"
    sha256 cellar: :any,                 big_sur:        "5308f18cbce6d40617e6f1499f7c0a12e95806ddfc22d898063d5144e6676c55"
    sha256 cellar: :any,                 catalina:       "c4d8e089c779b7a2dce577dd314df3bd3955b55d03c73db88e9b47801d98d6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac62b744285315381ba584bf90e78a11e98786e02a308c63a258aef76dbec16f"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL2_PATH=#{Formula["sdl2"].opt_prefix}",
                    "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{Formula["sdl2"].opt_lib}",
                    "-DSDL12DEVEL=ON",
                    "-DSDL12TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (lib/"pkgconfig").install_symlink "sdl12_compat.pc" => "sdl.pc"

    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be keg-only
    inreplace [bin/"sdl-config", lib/"pkgconfig/sdl12_compat.pc"], prefix, HOMEBREW_PREFIX
  end

  test do
    assert_predicate lib/shared_library("libSDL"), :exist?
    versioned_libsdl = "libSDL-1.2"
    versioned_libsdl << ".0" if OS.mac?
    assert_predicate lib/shared_library(versioned_libsdl), :exist?
    assert_predicate lib/"libSDLmain.a", :exist?
    assert_equal version.to_s, shell_output("#{bin}/sdl-config --version").strip

    (testpath/"test.c").write <<~EOS
      #include <SDL.h>

      int main() {
        SDL_Init(SDL_INIT_EVERYTHING);
        SDL_Quit();
        return 0;
      }
    EOS
    flags = Utils.safe_popen_read(bin/"sdl-config", "--cflags", "--libs").split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
