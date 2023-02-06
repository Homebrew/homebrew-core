class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.3/SDL2-2.26.3.tar.gz"
  sha256 "c661205a553b7d252425f4b751ff13209e5e020b876bbfa1598494af61790057"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/release[._-](\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f76f2fcea4ba2cf8a3f39058feb12cc8c33ff0238e00a9f848ede7a741a55476"
    sha256 cellar: :any,                 arm64_monterey: "6b6d0582ad5794f7b0ac5d5729e4d8e497da83aff753f4bfb182efdbf25c08ca"
    sha256 cellar: :any,                 arm64_big_sur:  "2461feeae42ea3e0d4c265a8141d5c7698f4158c84e5b4d99f40a7fabc146e63"
    sha256 cellar: :any,                 ventura:        "be08030ea0bc6bcac11b442b32d9e4ee181108e69c06037a1d4dc50ba69f62f2"
    sha256 cellar: :any,                 monterey:       "b6711573b652d8b909c2f8e3794c3aa7fa06ba2feebd933dfa7130cdabfcd6fb"
    sha256 cellar: :any,                 big_sur:        "e1a13332fbef7c42869c48909e1080137724dd5196366689f023422429aebdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8678f62d56ea037feece5fbee444c5e38d913d131d83129a0c194363fdc0d0"
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
