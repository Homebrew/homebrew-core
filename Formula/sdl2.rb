class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.1/SDL2-2.26.1.tar.gz"
  sha256 "02537cc7ebd74071631038b237ec4bfbb3f4830ba019e569434da33f42373e04"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/release[._-](\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2181835c08d17236b283ff45f7c18773b20be9e9ee17722a88d5c8e1c24d2a7f"
    sha256 cellar: :any,                 arm64_monterey: "d1bc5818ab60ed8b1b3420bc36fb7a0697cc57ee382f4cd6d2d65680059e38c9"
    sha256 cellar: :any,                 arm64_big_sur:  "b3b7bbb949ccb2b6419dec9bee4ea9d3eb7bb55ece9be442f64776ea2c5a188c"
    sha256 cellar: :any,                 ventura:        "d43cb34a35f315d063bf921d897b084340bedd54db558b55a1eb1df8a8e550b1"
    sha256 cellar: :any,                 monterey:       "c9072ab2b00476ba9217fbfb4020e95adae27feea054fd8b652ec667ceaae99b"
    sha256 cellar: :any,                 big_sur:        "6ff1980e0f65f260b45793d613be037bc3c16fd2fb517970be5a79cb1455d7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a045356cb0cde77aabe13188fdc86fb8bfda541c1e50253164edcca0b2c19c5"
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
