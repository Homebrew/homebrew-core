class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.56.tar.gz"
  sha256 "f62f3e15f95aade366ee6c03f291e8825c4689390a6be681535259a877259c58"
  license all_of: ["Zlib", "MIT-0"]
  revision 1
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9fa81c93ccaac2f1d2593b66b6964abbc4d3d503cc9985051b2ffc22b23737ef"
    sha256 cellar: :any,                 arm64_big_sur:  "f6debd32dfc5afe87c10af3558c8403eba7b11b5336e9743a845ee6d0e5c5bf5"
    sha256 cellar: :any,                 monterey:       "421b2ed2509c5137903a72d509c4d0370d31882e9dcf5ab4a4b821bc0a498ac1"
    sha256 cellar: :any,                 big_sur:        "f130548e7786274d35d87604adbd7c77237381e5cfcb3a105932d9d73be716b8"
    sha256 cellar: :any,                 catalina:       "23ede3121cb5e0bfd0d28df00f3b70bebef61032e803bf763da46298bfbcadae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d180113b4ff6d3098de92688c0c74321be325b6fda59b97af9359f2c32aa10"
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
