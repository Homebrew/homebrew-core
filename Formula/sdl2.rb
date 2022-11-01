class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.24.2/SDL2-2.24.2.tar.gz"
  sha256 "b35ef0a802b09d90ed3add0dcac0e95820804202914f5bb7b0feb710f1a1329f"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "653bf4aa1175485554362d32a89f2c24134b93c5f35655df362db5c0019440b7"
    sha256 cellar: :any,                 arm64_monterey: "1a3356f2dd3e61fb00f555f412a5f87f4674ae5264050a13e0a3845b9e3504cc"
    sha256 cellar: :any,                 arm64_big_sur:  "1123966cee8f09a82f0437e95c5eedf37c8d1799d1ecfa99882555927bd46f87"
    sha256 cellar: :any,                 monterey:       "ebb4d5c39c46b714bd6c0327bbc311c237621889436abdf832c2df3d6ecb03e4"
    sha256 cellar: :any,                 big_sur:        "d53d137ba30c207b46f375b9189a4bd11ddb0908eb376faabc8642d19f9253ba"
    sha256 cellar: :any,                 catalina:       "cbfdf2b80e88198ade5d1f5fefa2c747f0eb2c30b0eda388292c00ff9b981dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1afd7a08f011c31489816c12a468c5d13163cdf6d7491bf3cbb08e62037f1485"
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
