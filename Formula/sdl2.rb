class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.28.1/SDL2-2.28.1.tar.gz"
  sha256 "4977ceba5c0054dbe6c2f114641aced43ce3bf2b41ea64b6a372d6ba129cb15d"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34ff48eb9e8a5b9173c1228d7030dd62e303f21bc633dd4d11a18b6b0ed7019e"
    sha256 cellar: :any,                 arm64_monterey: "861d2f59e0fa9ea75afb37abcb7bdd69946b60e5e8cb3306defe53998a683b3c"
    sha256 cellar: :any,                 arm64_big_sur:  "c8306c4c9d68969f70625c844c7c666519c88fea26cdb0aed785e0f55e680647"
    sha256 cellar: :any,                 ventura:        "45da9c521d1f6e3e48e0ea481307e094a290c0855513d15cbe9fa375b27cc06a"
    sha256 cellar: :any,                 monterey:       "b54f275de745356a5b378a65325c15e7d0fd34b08c6afb54a1dda2271a19e089"
    sha256 cellar: :any,                 big_sur:        "08227757c086322f93a0c9d03f3063ac3abcb6aeb514d42834d1f1e618275fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec380ed99b4ff883070fc3fa09d14bdec3130a22e43c63d9d28eced406fd9c5"
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
