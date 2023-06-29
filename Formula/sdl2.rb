class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.28.0/SDL2-2.28.0.tar.gz"
  sha256 "d215ae4541e69d628953711496cd7b0e8b8d5c8d811d5b0f98fdc7fd1422998a"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "860a0b15fdc9ba442d8383dfe59a5c52321dcc40964574b00e5ce45e54787f31"
    sha256 cellar: :any,                 arm64_monterey: "7b355f84c3fc5b5dba2bfd7e940eff5b7244b6c8b16f9ec602a4eebcb43333e4"
    sha256 cellar: :any,                 arm64_big_sur:  "072dfd29b015615e0695837ac48e287f9f249e134973525285bdef96ffda34cc"
    sha256 cellar: :any,                 ventura:        "a7d3b5da21349115367fd1272948c66dd91c5a5f2d69afa9984ed0634fbbc25c"
    sha256 cellar: :any,                 monterey:       "80a15d253e22a7c3c7c8ac2c1254ac148ce1e3f748fccae94dd4ac3962204d43"
    sha256 cellar: :any,                 big_sur:        "6418301248ec005d9c5a1deaf0ec925a0aca6538aace4fa1cf4a0fdb08024407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d4f63b5c47791251b2ecc59de7e69c969cb11d44862dd6d2bce95824b432565"
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
