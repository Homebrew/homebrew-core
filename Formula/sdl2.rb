class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.16.tar.gz"
  sha256 "65be9ff6004034b5b2ce9927b5a4db1814930f169c4b2dae0a1e4697075f287b"
  license "Zlib"

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/href=.*?SDL2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "692492d5b9c0a6ac2b49cf8cd482df73e8a810b2929329ee66582008af1af957"
    sha256 cellar: :any,                 arm64_big_sur:  "6adac3ca2899ab923427b9b9322c8a4a412485ac7fe6448e276b4aae598f7a49"
    sha256 cellar: :any,                 monterey:       "e4602f036a26f4676b0bc522d38e4433cfc0a7a3c55c12e065724c51f06c4e65"
    sha256 cellar: :any,                 big_sur:        "71fe247bc197133b02186fac4e8f296d7f457a9507e0c77357b1069e5ee2ca61"
    sha256 cellar: :any,                 catalina:       "4634185a35d9fc37c8fc07f884e45e7e2fbaa3fdec615171e647a9e02c395bd4"
    sha256 cellar: :any,                 mojave:         "9966890d7d39147e75e92d6a7390ef5fb2f043b08f913e751638bdeef8c1c220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664cf8d5df1066a7d1bd4121e5805ac8bb7230e068237bbbb4654b7f085e7150"
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
