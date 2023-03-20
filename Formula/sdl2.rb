class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.4/SDL2-2.26.4.tar.gz"
  sha256 "1a0f686498fb768ad9f3f80b39037a7d006eac093aad39cb4ebcc832a8887231"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/release[._-](\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a954b24b4428eac2e7027292c44a5969bfecbbd9ac87afdfdc362a069307b652"
    sha256 cellar: :any,                 arm64_monterey: "aa051fa98baec1acfacce9f597be91a5c0fd4036ec015c3090a49c7e9e70c9e5"
    sha256 cellar: :any,                 arm64_big_sur:  "6d3554f531d5866e378b79f3820c433b3615fb862496810fcf0e60e92c116a74"
    sha256 cellar: :any,                 ventura:        "245e881d5555701e69a4e80d50118f6bf934e7ab80e7178d10ade10a43fd68f3"
    sha256 cellar: :any,                 monterey:       "78966f833a31bbeacd3e18c138bea29cfbb390b04c53c65703d85e75748bb572"
    sha256 cellar: :any,                 big_sur:        "013b1c7f5965ddb10160040cf15d4fd07fb5e0de4cc5f473d0875d1b22b11648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f1180236a7e9578d9ba9b6028d3b9b5e80763cfdb81b409f38423e1cdac333"
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
