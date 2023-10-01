class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.64.tar.gz"
  sha256 "3e308e817c7f0c6383225485e9a67bf1119ad684b8cc519038671cc1b5d29861"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b13aa6fa01d339b74f5f99b2e68b79b238c34182cd58b4ef476a9897706939dc"
    sha256 cellar: :any,                 arm64_ventura:  "ebad05b905bb7c02a03774c61739a80c873452c71005bd530f2a8631b90d18c7"
    sha256 cellar: :any,                 arm64_monterey: "575e6be5525e92350ec8dd7bd2d4c5bc20e448f0f5f010633b5267eb5d9175df"
    sha256 cellar: :any,                 arm64_big_sur:  "f3e027271fb43a3f7143116a44e76517f8e43fad149d44ef9689811f7ebf3f8a"
    sha256 cellar: :any,                 sonoma:         "201276a754b4120c12ff23a66b88f19ab61f057a7ead3b370925313f2d1627a2"
    sha256 cellar: :any,                 ventura:        "118f7c1daf22008b15b5853a93409f4cadbb73a6f43e25ddb7eb2d313d92ed37"
    sha256 cellar: :any,                 monterey:       "ed617022ec1e5e89c89fa4e34c607da0ddf27fb069b0fe5c7a72beb5a58b76a1"
    sha256 cellar: :any,                 big_sur:        "1636d3ca1c576aa88eb2cd946927467ec2627f2ec55d0b395c3a43141416c862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94fa84a28db17c9590035b1788a3935803d5eafded2c01560f6e1d14dd0f28ef"
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

      int main(int argc, char* argv[]) {
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
