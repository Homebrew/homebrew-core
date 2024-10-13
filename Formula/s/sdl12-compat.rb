class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.68.tar.gz"
  sha256 "63c6e4dcc1154299e6f363c872900be7f3dcb3e42b9f8f57e05442ec3d89d02d"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7629feebea88788075d1b222b1096b9f7c1a412fa7dfd5874cfc9ecedeb3cee3"
    sha256 cellar: :any,                 arm64_sonoma:   "4948b9d4e38766595d0c173458b97c00121834dd6b4161496a09fec4fc094950"
    sha256 cellar: :any,                 arm64_ventura:  "d8d666b4c119e5dadd9d338d12c59723adad83565e18612afaf934fcf58e2872"
    sha256 cellar: :any,                 arm64_monterey: "f5a78c668498f0507ffecfce91a2f690b46fc0adc91ed1c3bf207466c1d08f4d"
    sha256 cellar: :any,                 sonoma:         "e5a972e8c3bd9012f6dca3512f1953c4f7f9b1f1580b7066b930fa9fabc54150"
    sha256 cellar: :any,                 ventura:        "f355c15e6d99d002a44af8689e835ab14765f0abea078b40c1301283cbd28535"
    sha256 cellar: :any,                 monterey:       "30cbfb49ab9560fcce09b372ad986a74caa3007704012454f76cc4416dfa0e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac00966975256217cace0e9acf45e8659d5d668e16972a072eb6c298ff630fa2"
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
