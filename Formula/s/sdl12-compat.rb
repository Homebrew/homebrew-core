class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.74.tar.gz"
  sha256 "2588686c0972e1785829dc3bf436b543c317e6afa30a9b91d48013dd9c110e81"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80d8a2cd42d8764cbbee16712c04a51065c11a72a1978b57dd19f00f89b4a7c9"
    sha256 cellar: :any,                 arm64_sequoia: "b85875468644622ca2f5baed05224e2461749eaebc4adc68079545431b29bdf5"
    sha256 cellar: :any,                 arm64_sonoma:  "02cb6e2a03fa7c41c7bebb92f20ca0f71e960ceea9a96836a51d66016d50f14d"
    sha256 cellar: :any,                 sonoma:        "2aee87fd030a3169d43e4f39ab7976b2571e2f125ebe386c3be83846ffe87443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1734c5572ab95675715067ea7c53fae385edc3ac3f0e8d14dbdff5d7a6d46a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59672f32f8fdad034dd1ff77b8dfcaaf80d2ec67c3442bae351a28741fb561f3"
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
