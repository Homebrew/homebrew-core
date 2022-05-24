class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.22.tar.gz"
  sha256 "fe7cbf3127882e3fc7259a75a0cb585620272c51745d3852ab9dd87960697f2e"
  license "Zlib"

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/href=.*?SDL2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d299f67194020898fa457130d11ecc89beab6020d2d8ed6cb6c546ca91858f03"
    sha256 cellar: :any,                 arm64_big_sur:  "77512d6fc260326313d7c02d8442a967740d4b7e616a6995e87844dcf7a2f523"
    sha256 cellar: :any,                 monterey:       "eac3c4de97e453a8e26e142fae4f960b81685a6278193af27d9ab231a975c41c"
    sha256 cellar: :any,                 big_sur:        "cb7bd018480f11182cf123add9d2f409b2de0013eb40fc08ac94f79e5b8c4848"
    sha256 cellar: :any,                 catalina:       "fd1311f75f9b584bd8621ec419deb05a63f29de0e5ae8fd88b737186d5bd2e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3522d4ffdbae2fd6e413dd10027d7c645a87ea19ecd4443423fba7cf316c4d2"
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
