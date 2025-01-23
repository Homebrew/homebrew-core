class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.30.11/SDL2-2.30.11.tar.gz"
  sha256 "8b8d4aef2038533da814965220f88f77d60dfa0f32685f80ead65e501337da7f"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b87f0d34432faf3630ad1f7ed5a65b8387ffadc8eb51c936fe7e973642a8207d"
    sha256 cellar: :any,                 arm64_sonoma:  "6eed4d7882ace75c6831382cbadbdeb7cad356cdd5000fad7f0b2e7b17d917f8"
    sha256 cellar: :any,                 arm64_ventura: "47101386010f483cb135c3b0caa574c8912777277ec63afdd8216788e8dfc720"
    sha256 cellar: :any,                 sonoma:        "eb8211e78231337e7b2a50665a839d46254cac5a6cf6a88cef738ad81f7054cf"
    sha256 cellar: :any,                 ventura:       "9809878a8d7eab5b71acb0cdcccc528313896a99972ae251ca693032df7bb427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f53ea335f9990ec2aef849a995ea2d7b56db073ea4eb7fb8a34a53e4275d6970"
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
