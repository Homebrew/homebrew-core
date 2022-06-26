class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.52.tar.gz"
  sha256 "5bd7942703575554670a8767ae030f7921a0ac3c5e2fd173a537b7c7a8599014"
  license all_of: ["Zlib", "MIT-0"]
  revision 1
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9097849e4ee47c949ee9cd53fbc4fccc5d891027160c869ab0cd34d9780f0cf4"
    sha256 cellar: :any,                 arm64_big_sur:  "54eaa165d19da50d3ec01a1afd6bef64a94bbae939eb40322cfee9b889481366"
    sha256 cellar: :any,                 monterey:       "d1140b78795e656e6f37b048b95e0fecd025dc7dbbbbb95da4aebcda3daa2389"
    sha256 cellar: :any,                 big_sur:        "04e2f46b74b3109b41c43778e90bdabbad3aab42ba243f220b6e9baf120ef2d1"
    sha256 cellar: :any,                 catalina:       "b929d4c3832cdf6f8a8df785861b0fe5df4a7a4ca6e2a15e97351f5f0a9e07d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b8d0758cfba87d0ac1c02b441b12a4aa325770e425364e06429881fd54d8a3"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  conflicts_with "sdl", because: "sdl12-compat is a drop-in replacement for sdl"

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
