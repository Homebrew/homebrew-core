class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.30.12/SDL2-2.30.12.tar.gz"
  sha256 "ac356ea55e8b9dd0b2d1fa27da40ef7e238267ccf9324704850d5d47375b48ea"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](2(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01d65f57a37b57c348ca7ae87cd4ed3f3961cc0eed441281dcbeb633110b4084"
    sha256 cellar: :any,                 arm64_sonoma:  "c67d2542dbdf6845726df2e566d4e63591df4b6c44fcc1a21f3408625262e019"
    sha256 cellar: :any,                 arm64_ventura: "c1260efc60000776a0f8a88981e6c1b6b518cc6d5f87a1a9d2e65a10c6ccbd2e"
    sha256 cellar: :any,                 sonoma:        "dfb981e4147dd20be3774c57358655817eb5fd4147d6e8a6eac1cc202a29af10"
    sha256 cellar: :any,                 ventura:       "1209100c97f75111189ecced8bee0fdd7c3cfbfd1607362e7421c7881f491f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b87782d734aa8509f0c8b38b2105c4ace357bac3fc88be78ea9c9ca3b8ab37"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
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
