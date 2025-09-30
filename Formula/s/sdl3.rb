class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.2.22/SDL3-3.2.22.tar.gz"
  sha256 "f29d00cbcee273c0a54f3f32f86bf5c595e8823a96b1d92a145aac40571ebfcc"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2284f75bc7fd0a84ce2410efddbc637a2903c2be73a83e6a4ff008762c902a5"
    sha256 cellar: :any,                 arm64_sequoia: "e8f94c94ee5a7ac70b84488f274bfad726da22f9a87b95e11e502129c6b0cafc"
    sha256 cellar: :any,                 arm64_sonoma:  "ae9c02119ef1559ead149460e0479fc3edfc0a86fb5c64dcf39721435ef5d204"
    sha256 cellar: :any,                 arm64_ventura: "7fc2aac80a434868e9736165ba7cba3a94c74b9bbcc90b0e9d4c78c1926d7edc"
    sha256 cellar: :any,                 sonoma:        "596d0680c040b9f0042da4c9df7ae4a67956b8c8ab6c880fa4eae3d1f138ed54"
    sha256 cellar: :any,                 ventura:       "761a2b603e8eb92a8f558b1f61545d7e5565bfcd86d53b9b91a5698ab7d433bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f6bae46a1bc5622502a59f15c6ab01d74d879cb302a4abe7c41dca2d2549988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0168e51694161204dd09eabd545557334a4f7248d7023ec0633054eaf0bb3124"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    inreplace "cmake/sdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

    args = [
      "-DSDL_HIDAPI=ON",
      "-DSDL_WAYLAND=OFF",
    ]

    args += if OS.mac?
      ["-DSDL_X11=OFF"]
    else
      ["-DSDL_X11=ON", "-DSDL_PULSEAUDIO=ON"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~CPP
      #include <SDL3/SDL.h>
      int main() {
        if (SDL_Init(SDL_INIT_VIDEO) != 1) {
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    CPP
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lSDL3", "-o", "test"
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system "./test"
  end
end
