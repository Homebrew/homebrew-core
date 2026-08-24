class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.14/SDL3-3.4.14.tar.gz"
  sha256 "30d4aa2b3037718142b32dffd4e72f917ebb6cc5227150e7bb9c45efb2153aeb"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "259aa68688ef848e5c44755eb021b6024b3f6e68e3449a5d74d8bdad7df3b0d6"
    sha256 cellar: :any, arm64_sequoia: "012d5bb068548cb42df1fd6ab231a8ef76e706a82822d84ed71a10be7f155263"
    sha256 cellar: :any, arm64_sonoma:  "7fb79c750712a4cbd9e8263cce54ae43c789cf1016c70684ebe04fad87d70768"
    sha256 cellar: :any, sonoma:        "59bac3409af506f51839fc260b951d16a4f264561c6d9d0715f98f4098300ad5"
    sha256 cellar: :any, arm64_linux:   "fbf7af7fa55a3e8daf045e3c1e1b7e36c1b3743d5f2f5550611f7647029af7be"
    sha256 cellar: :any, x86_64_linux:  "3d24a575e814b1f349e4df8aa0b2657acfcf2fef7ab2cbf34b44d485e981b6d9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    # Features are built into library if dependency is found at build-time.
    # These are then enabled at runtime if library can be dynamically loaded,
    # so we can provide extra features via build-only dependencies. This includes
    # PipeWire and Wayland used on modern Linux which have large dependency trees.
    depends_on "libxkbcommon" => :build
    depends_on "mesa" => :build
    depends_on "pipewire" => :build
    depends_on "wayland" => :build

    # Runtime dependencies are for older PulseAudio and X11. These are used if
    # running a Linux container on macOS and should have higher compatibility
    depends_on "libx11" => :no_linkage
    depends_on "libxcursor" => :no_linkage
    depends_on "libxext" => :no_linkage
    depends_on "libxfixes" => :no_linkage
    depends_on "libxi" => :no_linkage
    depends_on "libxrandr" => :no_linkage
    depends_on "libxscrnsaver" => :no_linkage
    depends_on "pulseaudio" => :no_linkage
  end

  def install
    inreplace "cmake/sdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

    args = %w[
      -DSDL_TESTS=OFF
      -DSDL_X11_XTEST=OFF
    ]

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
