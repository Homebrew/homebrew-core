class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.72.tar.gz"
  sha256 "daf6726b89d71120395472dd3cbc16c7a3b0bcbe2c1495de90885d4c2b266d3e"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2e3618480a324e387efbe8c57da95fe5c2bc9abf3fd07586fb735431832ccac"
    sha256 cellar: :any,                 arm64_sequoia: "3be1263a87b1fb9d65b1be1aa2b2e8edee92eb7c0d6da61a8f2b509e2c9e8416"
    sha256 cellar: :any,                 arm64_sonoma:  "e1d7ae2dfeab8aaa5e2bc45c0fd1934ad6bcabc0d3ee5e091978d52231173fb6"
    sha256 cellar: :any,                 sonoma:        "8a8beb898caa9edb92eb332f91289bb40070c7b700557685fb357550faa9991e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45d457557e4a994234c618ffb3201fa48f9f528a602f9cd4be7dcbb8d876c34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62513e0453720dba860aa9ab6a89942ec5a61942b2cfec46e6bc62b72f000ff5"
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
