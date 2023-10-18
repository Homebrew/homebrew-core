class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.28.4/SDL2-2.28.4.tar.gz"
  sha256 "888b8c39f36ae2035d023d1b14ab0191eb1d26403c3cf4d4d5ede30e66a4942c"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6fe97069d2c299cef1d407c11403714c20a50fd95a2ce16609e7477d792a9b9"
    sha256 cellar: :any,                 arm64_ventura:  "ebb73d39781af471e402732e1ff8f683343f58dbe6c97dfb408cb814f95ed5ff"
    sha256 cellar: :any,                 arm64_monterey: "d69978b66c194ae2d087322245c783083a80ca14da243f3bb1f45397ed4dbfcf"
    sha256 cellar: :any,                 sonoma:         "d42c77061a90fcdf02f4a5180f32599ff75321285fff06d786fe9cc213e76f8d"
    sha256 cellar: :any,                 ventura:        "9cd70d93ffac88df31be73fb88c488114b200ae3a87e51acfb6e2fc6d27ec916"
    sha256 cellar: :any,                 monterey:       "92daa8144a71de0224e8d09f3ecba21dca93344eb109529394d498c4967e8fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "004689b7441721c1e95e4706fe2bc781b028f4721ba079a89457ecbcb9debc8a"
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
