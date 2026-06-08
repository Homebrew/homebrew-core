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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "56dc659b94776ea6230f7b978c84fcb4df46a5970a565960a12805ae922eb9a6"
    sha256 cellar: :any,                 arm64_sequoia: "fe94f9cd0d788a8b77c8704b7681f59edc67e20c801b22b4aba248d27a58e2dd"
    sha256 cellar: :any,                 arm64_sonoma:  "ec62b168684492e1686bbc7d308f8fc2f4f03858b0d5f4eb27299acb2c39bac6"
    sha256 cellar: :any,                 sonoma:        "84eefd7e2780806b46ad5b0fc88c9d6d8a2025a74f41237226eb964bc3ece057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c85d1ec8070299e38628a852d5dc491f11d8e13f9010908bc8716b8ced7f2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5325fbcdb88813f34b205c7bdb1a52a9f4d282c31d4da5518941cbfbd119c230"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL2_PATH=#{Formula["sdl2"].opt_prefix}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["sdl2"].opt_lib)}",
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
