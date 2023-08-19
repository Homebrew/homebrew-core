class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.28.2/SDL2-2.28.2.tar.gz"
  sha256 "64b1102fa22093515b02ef33dd8739dee1ba57e9dbba6a092942b8bbed1a1c5e"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cfa4fcd327d0a1bf1241df0b25c33c6e8912dd25fb0e373b85f34a696ccda894"
    sha256 cellar: :any,                 arm64_monterey: "c0bbcfca51e71baad1a0b7e877eb3e8b60f510216be65fe42184e8ef34175fd1"
    sha256 cellar: :any,                 arm64_big_sur:  "8b52a1ca7da7138fa8465387358e3908d52a65e483342a8134f51bf3bda983c2"
    sha256 cellar: :any,                 ventura:        "dfc44316769e87fd93c96fb2b4b74caa98e89b96acdc98c547fc1e1e50d6efa3"
    sha256 cellar: :any,                 monterey:       "f6bc882a2a91d8e974fdb55e6dda145477d4397893ca0c1962106d89ed475d52"
    sha256 cellar: :any,                 big_sur:        "c7ea523fc46fbc83d51fd19c52bc26f3c06b4a1318f8522cc94b1e14821c9e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a37ed6dd4edc283c1e310f2bee751fabd8b6aa27fdb9d1ad7f7cdcd3d9790d"
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
