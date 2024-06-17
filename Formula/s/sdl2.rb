class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.30.3/SDL2-2.30.3.tar.gz"
  sha256 "820440072f8f5b50188c1dae104f2ad25984de268785be40c41a099a510f0aec"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c72d10aa8917464d64ef798a954c793780f9bc06ddda89efc35cda9f8faea50c"
    sha256 cellar: :any,                 arm64_ventura:  "29c5addcc012d9a07b57fa1056dcdafe1f10effee899e23e2ea80b934dd8717a"
    sha256 cellar: :any,                 arm64_monterey: "1d1b2dcc16d62cc0c973d052657c4677a6f36ad614f8d75b27d7bb69a4a3072b"
    sha256 cellar: :any,                 sonoma:         "ba00d374737a8172c9bce91454e8e91e7bbb38cb947ffd0e015045525cab0b31"
    sha256 cellar: :any,                 ventura:        "10b5474186913990eccf356d36688ba8887c90a5b2a3ece81e52c8e559e0dd7b"
    sha256 cellar: :any,                 monterey:       "566f1cb5554609bb53da300caa83b6f005c822493dcce5f0fa88e02fb1dba92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9300479781de3296084e3590c1583085b05eb12371c8d302d2f4c7df7e5602"
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
    args += if OS.mac?
      %w[--without-x]
    else
      %w[
        --disable-rpath
        --enable-pulseaudio
        --enable-pulseaudio-shared
        --enable-video-dummy
        --enable-video-opengl
        --enable-video-opengles
        --enable-video-x11
        --enable-video-x11-scrnsaver
        --enable-video-x11-xcursor
        --enable-video-x11-xinerama
        --enable-video-x11-xinput
        --enable-video-x11-xrandr
        --enable-video-x11-xshape
        --enable-x11-shared
        --with-x
      ]
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
