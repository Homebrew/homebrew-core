class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.20/SDL3-3.4.20.tar.gz"
  sha256 "f3bb06f55bed9557227a700af2ea62e49497ebdf58037732a731a5fb3ef8581f"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "32a702e3769562e9ef607ca5844db08eb3e491cabc9484694b112252a4ab24dd"
    sha256 cellar: :any, arm64_tahoe:       "5cc8db9dc41553bd56dcb0e6fd56591b9ac4f464ea29403c11936ec69043ac13"
    sha256 cellar: :any, arm64_sequoia:     "c1b7b92cbf6446d1f3a228accd9d158c12742b39fadc8431b3624233bcadd202"
    sha256 cellar: :any, arm64_linux:       "5b6cf2966f7e42e8c1a4d7639d6cf4b7a79adf501b2a798f4a49049f6865e799"
    sha256 cellar: :any, x86_64_linux:      "21efc3443f4dd34b94506c85d53d2c20bbf206f0779ac458aafa5b8551c28ee6"
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

  deny_network_access!

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
