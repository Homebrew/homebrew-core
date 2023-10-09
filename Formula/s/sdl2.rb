class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.28.3/SDL2-2.28.3.tar.gz"
  sha256 "7acb8679652701a2504d734e2ba7543ec1a83e310498ddd22fd44bf965eb5518"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b78dcbdbfee6298d248eabb06468d7f991f2495104344f16dd35e503a6a0b1aa"
    sha256 cellar: :any,                 arm64_ventura:  "764084498b650c302759a7eb26b1dc3886e650d8b6ac3f3f6f560a9cfe225b5e"
    sha256 cellar: :any,                 arm64_monterey: "db232b4a952027efb697a56826442de66ab84328c2bc0b9e8f2b23465a1bcb2e"
    sha256 cellar: :any,                 arm64_big_sur:  "003bc7fa2207369cd2ed794d3f88df844c9961bd7e172d1edb2f6aa20575474f"
    sha256 cellar: :any,                 sonoma:         "4bff4927d69d7258b07540782a74d46d822d1113a8cbde0839f3b7fd1547b52e"
    sha256 cellar: :any,                 ventura:        "7963704fdcfa3b1dbfbc82a18951109d9fddcdede7215fd9fa15c0709f9b98f1"
    sha256 cellar: :any,                 monterey:       "63d2c2dab020fc0cbd13c815883108174eba3d394220724ae4baa561266a2e1e"
    sha256 cellar: :any,                 big_sur:        "dc5f0129e21d34697904f54526c7c9f609b0b29cca456fd8f401b6abc7665e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0475ec88b9f73de4f52fac616899a7d1cfa0ca127530abe1e2e7a83fb973cc5b"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "SDL2"

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
