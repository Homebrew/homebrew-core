class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.24.1/SDL2-2.24.1.tar.gz"
  sha256 "bc121588b1105065598ce38078026a414c28ea95e66ed2adab4c44d80b309e1b"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b673806d35fb41c15bc5f9d473f31eaad5b2ee005ba23f7f01831cacff11f15a"
    sha256 cellar: :any,                 arm64_big_sur:  "5e048d2d1ee769e0bb0795f7dc0fbadb1178e8f204bbbc04b9865fbe6768e49a"
    sha256 cellar: :any,                 monterey:       "283a47d83c23623e4b08ce215589316f50794fe2c0dfd8691937dc3d759def0e"
    sha256 cellar: :any,                 big_sur:        "4ff206eee0e83b39c6f1cd93a535c54423b730d712639fe55c5939a5c05d29e4"
    sha256 cellar: :any,                 catalina:       "0e76309146d71f62229da8718ac739f3ba254a3ca1d00bb2150294e55339c9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce66108dbe2b04b7ca18b24d0c8a82512e1b5a903ca960db5b1a98a4b5630b1"
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
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    # We have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace "sdl2.pc.in", "@prefix@", HOMEBREW_PREFIX

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
