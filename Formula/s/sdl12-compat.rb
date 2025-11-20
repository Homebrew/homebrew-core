class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.70.tar.gz"
  sha256 "b8350cc400b9605dd5e319f451f09d5d6e70bb1dfc22cd67f718b3ffc16ebb7c"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38d6c9f697f5da1acfb78654789c8d479155edccb2453f8f73582f7681957351"
    sha256 cellar: :any,                 arm64_sequoia: "ab2a011e0cfcd8a7a8492ad825f234faf220131017f384e657a41fa96f03d4b1"
    sha256 cellar: :any,                 arm64_sonoma:  "662af03fff83b2f69646306df4ef414bfb1bfa10f62cc262fb720eaacee9a3b3"
    sha256 cellar: :any,                 sonoma:        "f94f75238561b2dc71492cbc54180cfdc5168ff4925fabf7f9cb1f62548dc572"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26db3e5b098f923113bc5e214457fab0113eaacc4b623250e9844a244262dca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4422b6bd772c36cacb6486cd40c31b566ee02f2f00d50d7c1566be87cc437593"
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
