class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/prerelease-3.1.0/SDL3-3.1.0.tar.xz"
  sha256 "0eac19111cde216644fa70af953db3eaea06fad198b5f5a8bc899164768054e7"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "libusb"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "jack"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "mesa" # OpenGL
    depends_on "pulseaudio"
    depends_on "systemd" # udev
    depends_on "wayland"
    depends_on "xinput"
  end

  def install
    sdl_options = %W[
      -DSDL_SHARED=ON
      -DSDL_STATIC=ON
      -DSDL_STATIC_PIC=ON
      -DSDL_VENDOR_INFO=Homebrew
      -DSDL_ALSA_SHARED=OFF
      -DSDL_HIDAPI_LIBUSB_SHARED=OFF
      -DSDL_IBUS=OFF
      -DSDL_JACK_SHARED=OFF
      -DSDL_KMSDRM=OFF
      -DSDL_PIPEWIRE=OFF
      -DSDL_PULSEAUDIO_SHARED=OFF
      -DSDL_SNDIO=OFF
      -DSDL_WAYLAND_LIBDECOR=OFF
      -DSDL_WAYLAND_SHARED=OFF
      -DSDL_X11=#{OS.linux?}
      -DSDL_X11_SHARED=OFF
    ]
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DPERL_EXECUTABLE=#{DevelopmentTools.locate("perl")}",
                    *sdl_options,
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL3/SDL.h>
      int main() {
        int result = SDL_Init(SDL_INIT_EVENTS);
        SDL_Quit();
        return result;
      }
    EOS
    system "pkg-config", "--validate", "sdl3"
    pkg_config_flags = shell_output("pkg-config --cflags --libs sdl3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
