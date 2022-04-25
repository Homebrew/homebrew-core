class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.22.tar.gz"
  sha256 "fe7cbf3127882e3fc7259a75a0cb585620272c51745d3852ab9dd87960697f2e"
  license "Zlib"

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/href=.*?SDL2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3cbd5b0ac7c9f4aedfa57dcfa02cff1e88013e8713cd5ec76d185897ee052b4f"
    sha256 cellar: :any,                 arm64_big_sur:  "7aca35ed5898e9dbcce4fa5372520f13626224d1600f391e70124012eeb1d0af"
    sha256 cellar: :any,                 monterey:       "2f9879903f7c18cef28684ee6718510baed17d1dcafc01416da6a35a29f0a1af"
    sha256 cellar: :any,                 big_sur:        "0a28562932bdf7d4f5b7528297d8a0d3a8e5ce04f67386110bc785800018f3bf"
    sha256 cellar: :any,                 catalina:       "9469eff3f8d7ddc9064eb8223cd220d8b1934fd6b5205199a8eb7bf50d84df04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1c80d0712cd623beb51bdfcfd9494b6b62639dcd70f8ae10f947731b7254236"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "xinput"
    depends_on "pulseaudio"
  end

  def install
    # We have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --enable-hidapi]
    args << if OS.mac?
      "--without-x"
    else
      args << "--with-x"
      args << "--enable-pulseaudio"
      args << "--enable-pulseaudio-shared"
      args << "--enable-video-dummy"
      args << "--enable-video-opengl"
      args << "--enable-video-opengles"
      args << "--enable-video-x11"
      args << "--enable-video-x11-scrnsaver"
      args << "--enable-video-x11-xcursor"
      args << "--enable-video-x11-xinerama"
      args << "--enable-video-x11-xinput"
      args << "--enable-video-x11-xrandr"
      args << "--enable-video-x11-xshape"
      "--enable-x11-shared"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
