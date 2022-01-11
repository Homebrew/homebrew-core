class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.20.tar.gz"
  sha256 "c56aba1d7b5b0e7e999e4a7698c70b63a3394ff9704b5f6e1c57e0c16f04dd06"
  license "Zlib"

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/href=.*?SDL2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b4b6a1a7970fbfded9389f92e468f119046c4f4e01af22c31e554caaa752e3c"
    sha256 cellar: :any,                 arm64_big_sur:  "e36fd1e12b902f813218cf9814b6630b81e5313aeae29cbdd549238cb160aa0e"
    sha256 cellar: :any,                 monterey:       "fab140fbf55d75ddfb01d709cd8205d338ed7aad49fd8294d89e9e274f39eeb1"
    sha256 cellar: :any,                 big_sur:        "4993f3b619580b2f42c794b2174f5577acf8aa83f26b1b0c60c9ae7a427888c6"
    sha256 cellar: :any,                 catalina:       "c208bc07789bc18e15b5efc73a406bf0fc5186db304fcf4e472b95955de5a298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03812e46b705635bee5b9252f0a95ee138c8239d3756c0cea8728c0f8e8701bb"
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
