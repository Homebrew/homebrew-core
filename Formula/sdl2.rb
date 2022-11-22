class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.0/SDL2-2.26.0.tar.gz"
  sha256 "8000d7169febce93c84b6bdf376631f8179132fd69f7015d4dadb8b9c2bdb295"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0d6ef9850408f81f07078c413227a322f6f65166c631a18cbbc2c6f230cb087"
    sha256 cellar: :any,                 arm64_monterey: "7a77adb962ca34b43371e732ae23921e8c20b14c9ec453efc77cbeac9cae96ee"
    sha256 cellar: :any,                 arm64_big_sur:  "160b90bf0d2cfbdab6ef6ce0671b30991c5eb1b44f742ec623e20f3c9648b366"
    sha256 cellar: :any,                 monterey:       "68e219bec783fe43fac0bdf2224d71e295b7d102f59fcce76c181689d59c6b09"
    sha256 cellar: :any,                 big_sur:        "0e476c1ac1b42f2997e7a04ee7816be50bfc03a4db8edb6572895816736433d9"
    sha256 cellar: :any,                 catalina:       "dba32a7de53794fb1f2473f4b94b22795a63546cd6d3a1e1e0c4249c74c0d632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c7f1d928883ea2661a259209252512f413809b0effde7c6dffa120e8cff83e"
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
