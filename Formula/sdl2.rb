class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.5/SDL2-2.26.5.tar.gz"
  sha256 "ad8fea3da1be64c83c45b1d363a6b4ba8fd60f5bde3b23ec73855709ec5eabf7"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/release[._-](\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0fba66630fffbe92c9ada6b7e7e58e1a4eb1ddf371b6ea2011e4746a22815142"
    sha256 cellar: :any,                 arm64_monterey: "315c5e6a740b96ebd335f3487b4af1d36fb4b7f88c51e8b8d9df8a13a905ffc4"
    sha256 cellar: :any,                 arm64_big_sur:  "5427cf5fab57ea809f5e5ed7bf15a8cc5e5458d3a2bd2fdc8cba5f8e68ef5f04"
    sha256 cellar: :any,                 ventura:        "303c697da4196183690739e32d6e20afe25ec7db3d8bb1949fe967ef28dc1ba3"
    sha256 cellar: :any,                 monterey:       "8f814aa8a0209a6863af528ad329d07060f14a15b5d90ad0401a606102377b32"
    sha256 cellar: :any,                 big_sur:        "96c97c19d4bbdc6a3a8e3120b2f926e84e094e5365b06459d37404d8d8b4a97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f983da157436e8cbcbc5a99da1b05a4398017c70206e41241bcdd01862a053a"
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
