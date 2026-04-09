class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.76.tar.gz"
  sha256 "e889ac9c7e8a6bdfc31972bf1f1254b84882cb52931608bada62e8febbf0270b"
  license all_of: ["Zlib", "MIT-0"]
  compatibility_version 1
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "72161caba641a583c35ae7329d312e133e075d22181e6e73b05ee419606c02ef"
    sha256 cellar: :any,                 arm64_sequoia: "2f0e4787c520344e1ce8e10f60c1b9d671a17d7a8895e38ce96b517fc23021e5"
    sha256 cellar: :any,                 arm64_sonoma:  "99b0dba0da565a052dbb4ec3791f81a7880c20de8e69d2aa0e40a68001a9dc7c"
    sha256 cellar: :any,                 sonoma:        "49274bc46c2f0f2ba1494e4ac6e70f494c894e0e6559835d4f7cc3f7c601ceed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4fe54f8946efbcc8db2e5775f09ece08c6fc0b7e141ad49c7e0caed0cf4a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0510ee9c54c6ce20809c5bbad6e295d4cd1c280f64829f1ac2c1331863a7bbb9"
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
    assert_path_exists lib/shared_library("libSDL")
    versioned_libsdl = "libSDL-1.2"
    versioned_libsdl << ".0" if OS.mac?
    assert_path_exists lib/shared_library(versioned_libsdl)
    assert_path_exists lib/"libSDLmain.a"
    assert_equal version.to_s, shell_output("#{bin}/sdl-config --version").strip

    (testpath/"test.c").write <<~C
      #include <SDL.h>

      int main(int argc, char* argv[]) {
        SDL_Init(SDL_INIT_EVERYTHING);
        SDL_Quit();
        return 0;
      }
    C
    flags = Utils.safe_popen_read(bin/"sdl-config", "--cflags", "--libs").split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
