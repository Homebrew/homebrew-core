class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.60.tar.gz"
  sha256 "029fa24fe9e0d6a15b94f4737a2d3ed3144c5ef920eb82b4c6b30248eb94518b"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "292eaaa1f35a83cafc39a798a34ecdb76b56b501ac2a31ca2cb3c52e161ef7e5"
    sha256 cellar: :any,                 arm64_monterey: "7bdc7c58142535f506465101e86b38b1727384fe81f7ad1c25fa6074c4bfb1ed"
    sha256 cellar: :any,                 arm64_big_sur:  "d9f5c0261ff4fc5d30477efd302f7409bdee96dbaa253ab48c0402d37bc1e987"
    sha256 cellar: :any,                 ventura:        "5bb9c526395b1324b66fe77ca34ef51805449f6fd36f8bf9b52f7dc51a5a419e"
    sha256 cellar: :any,                 monterey:       "4f7fad9a3c8d217a3bba342ff71c8cde5ef86f54ed82a592bda60a7e66088f4c"
    sha256 cellar: :any,                 big_sur:        "b943cf89e1851b7b86a243592a69bf7f918ea293ff4f199daab57a631d4a457b"
    sha256 cellar: :any,                 catalina:       "22c99c0480288cc108a294a19674a33e2758919a1055932e3aa4b8881140b091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b523c9bc9c45a2fe742b8b1705c7984efa0920ca1f54f32ca72e6bec61c675ac"
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
