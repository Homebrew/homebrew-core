class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.0/SDL2-2.26.0.tar.gz"
  sha256 "8000d7169febce93c84b6bdf376631f8179132fd69f7015d4dadb8b9c2bdb295"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79da44df913052bbccd4d04c19f30f63b37873a24303392e028a8da4fa63ae9a"
    sha256 cellar: :any,                 arm64_monterey: "562ab43c40806657c487d635bcbd7b6c92da6b613b74aec68205d6372e049fbe"
    sha256 cellar: :any,                 arm64_big_sur:  "ab30c410aff6dab70d7334b310b7189003b129803b845a3658b589d60f77ff10"
    sha256 cellar: :any,                 ventura:        "6ccced0a1eb6b5e13f40fd3cc61aafe6a616e806687ce2957d5185441fd5498f"
    sha256 cellar: :any,                 monterey:       "439ba2cf4becefadda6c9b06f3fa4b520d5b883afb65beca199859323ffe4d7e"
    sha256 cellar: :any,                 big_sur:        "a9de785f7457bcbbe02e8154543210935f03de0914ac898913c4e28c923ae8c4"
    sha256 cellar: :any,                 catalina:       "c5cc02c981aa73ae82c98b19d14124f3f0e9dfd11820dc09ae864f1d96ab2a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c03b39c21dfc41b077de93fb29d5c2851699f6076ea905bab0a79ba21d1c6d"
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
