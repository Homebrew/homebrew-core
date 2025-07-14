class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.32.8/SDL2-2.32.8.tar.gz"
  sha256 "0ca83e9c9b31e18288c7ec811108e58bac1f1bb5ec6577ad386830eac51c787e"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ccce09ed346668bd6c1e990be37c9b84ab93824211bc6e407f856adaff20a885"
    sha256 cellar: :any,                 arm64_sonoma:  "49d38f1d199893861ab9c535b2a90d6fa339c3880e8d941d3da328c8ef3393e9"
    sha256 cellar: :any,                 arm64_ventura: "b709f4f2bb61ae5ef6bf769b40c61c50bc941e22fc8b48a9a7ad1b82eb5f44a8"
    sha256 cellar: :any,                 sonoma:        "19b17973c310944f8cd81ae911306b5b98849e9b1b3f8609c3134e79cbb9b392"
    sha256 cellar: :any,                 ventura:       "2b0d9b00446a44489a81fd2572e31e3578de957d87a98df678429142ec197b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01be8b259743124645c252522b2fa2cf32b18fabff5c1aabe306452a8ef15923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8125ef91c82aac016da1384a47ad7840b4b15a3f3d2f2ca50b4d29ef5cb9d95d"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "mesa" => :build
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "pulseaudio"
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
